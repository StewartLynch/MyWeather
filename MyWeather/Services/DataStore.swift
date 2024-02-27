//
// Created for MyWeather
// by  Stewart Lynch on 2024-02-26
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import Foundation

@Observable
class DataStore {
    var forPreviews: Bool
    var cities: [City] = []
    let filemanager = FileManager()
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            if filemanager.fileExists() {
                do {
                    let data = try filemanager.readFile()
                    cities = try JSONDecoder().decode([City].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveCities() {
        if !forPreviews {
            do {
                let data = try JSONEncoder().encode(cities)
                let jsonString = String(decoding: data, as: UTF8.self)
                try filemanager.saveFile(contents: jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
