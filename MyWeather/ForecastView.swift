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
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                Text("Fetching Weather...")
            } else {
                if let currentWeather {
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    Text(Date.now.formatted(date: .omitted, time: .shortened))
                    Image(systemName: currentWeather.symbolName)
                        .renderingMode(.original)
                        .symbolVariant(.fill)
                        .font(.system(size: 60.0, weight: .bold))
                        .padding()
                        .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.secondary.opacity(0.2))
                        )
                    let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                    Text(temp)
                        .font(.title2)
                    Text(currentWeather.condition.description)
                        .font(.title3)
                    AttributionView()
                }
            }
        }
        .padding()
        .task {
            isLoading = true
            Task.detached { @MainActor in
                currentWeather = await weatherManager.currentWeather(for: CLLocation(latitude: 49.320991, longitude: -123.074718))
            }
            isLoading = false
        }
    }
}

#Preview {
    ForecastView()
}
