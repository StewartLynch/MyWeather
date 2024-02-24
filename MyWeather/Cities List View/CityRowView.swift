//
// Created for MyWeather
// by  Stewart Lynch on 2024-02-24
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI
import WeatherKit

struct CityRowView: View {
    let weatherManager = WeatherManager.shared
    @Environment(LocationManager.self) var locationManager
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    @State private var timezone: TimeZone = .current
    let city: City
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let currentWeather {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.title)
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                Text(currentWeather.date.localTime(for: timezone))
                                    .bold()
                            }
                            Spacer()
                            let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                            Text(temp)
                                .font(.system(size: 60, weight: .thin, design: .rounded))
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        Text(currentWeather.condition.description)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background {
            if let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
            }
        }
        .task(id: city) {
            await fetchWeather(for: city)
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    CityRowView(city: City.mockCurrent)
        .environment(LocationManager())
}
