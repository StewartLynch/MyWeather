//
// Created for MyWeather
// by  Stewart Lynch on 2024-02-22
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import Foundation
import CoreLocation

struct City: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static var cities: [City] {
        [
            .init(name: "Paris, France", latitude: 48.856788, longitude: 2.351077),
            .init(name: "Syndney, Australia", latitude: -33.872710, longitude: 151.205694),
            .init(name: "Washington, DC", latitude: 38.895438, longitude: -77.031281)
        ]
    }
    
    static var mockCurrent: City {
        .init(name: "North Vancouver", latitude: 49.320991, longitude: -123.074718)
    }
}
