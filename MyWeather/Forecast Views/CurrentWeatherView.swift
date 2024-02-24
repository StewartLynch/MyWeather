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

struct CurrentWeatherView: View {
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: String?
    let lowTemperature: String?
    let timezone: TimeZone
    var body: some View {
        Text(currentWeather.date.localDate(for: timezone))
        Text(currentWeather.date.localTime(for: timezone))
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
        if let highTemperature, let lowTemperature {
            Text("H: \(highTemperature)  L:\(lowTemperature)")
                .bold()
        }
        Text(currentWeather.condition.description)
            .font(.title3)
    }
}

