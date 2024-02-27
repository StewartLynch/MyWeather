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


import SwiftUI

@main
struct MyWeatherApp: App {
    @State private var locationManager = LocationManager()
    @State private var store = DataStore()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
                    .onAppear {
                        print(URL.documentsDirectory.path())
                    }
            } else {
                LocationDeniedView()
            }
        }
        .environment(locationManager)
        .environment(store)
    }
}
