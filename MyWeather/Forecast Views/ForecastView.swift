//
// Created for MyWeather
// by  Stewart Lynch on 2024-02-19
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch

// 49.320991, -123.074718

import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    @Environment(LocationManager.self) var locationManager
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var hourlyForecast: Forecast<HourWeather>?
    @State private var dailyForecast: Forecast<DayWeather>?
    @State private var isLoading = false
    @State private var showCityList = false
    @State private var timezone: TimeZone = .current
    
    var highTemperature: String? {
        if let high = hourlyForecast?.map({$0.temperature}).max() {
            return weatherManager.temperatureFormatter.string(from: high)
        } else {
            return nil
        }
    }
    
    var lowTemperature: String? {
        if let low = hourlyForecast?.map({$0.temperature}).min() {
            return weatherManager.temperatureFormatter.string(from: low)
        } else {
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let selectedCity {
                    if isLoading {
                        ProgressView()
                        Text("Fetching Weather...")
                    } else {
                        Text(selectedCity.name)
                            .font(.title)
                        if let currentWeather {
                            CurrentWeatherView(
                                currentWeather: currentWeather,
                                highTemperature: highTemperature,
                                lowTemperature: lowTemperature,
                                timezone: timezone
                            )
                        }
                        Divider()
                        if let hourlyForecast {
                            HourlyForecastView(
                                hourlyForecast: hourlyForecast,
                                timezone: timezone
                            )
                        }
                        Divider()
                        if let dailyForecast {
                            DailyForecastView(dailyForecast: dailyForecast, timezone: timezone)
                        }
                        AttributionView()
                            .tint(.white)
                    }
                }
            }
        }
        .contentMargins(.all, 15, for: .scrollContent)
        .background {
            if selectedCity != nil,
               let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom) {
            Button {
                showCityList.toggle()
            } label: {
                Image(systemName: "list.star")
            }
            .padding()
            .background(Color(.darkGray))
            .clipShape(.circle)
            .foregroundStyle(.white)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .fullScreenCover(isPresented: $showCityList) {
            CitiesListView(currentLocation: locationManager.currentLocation, selectedCity: $selectedCity)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                selectedCity = locationManager.currentLocation
                if let selectedCity {
                    Task {
                        await fetchWeather(for: selectedCity)
                    }
                }
            }
        }
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
        }
        
        .task(id: selectedCity) {
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
            hourlyForecast = await weatherManager.hourlyForecast(for: city.clLocation)
            dailyForecast = await weatherManager.dailyForecast(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
}
