//
// Created for MyWeather
// by  Stewart Lynch on 2024-02-23
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI

struct CitiesListView: View {
    @Environment(\.dismiss) private var dismiss
    let currentLocation: City?
    @Binding var selectedCity: City?
    var body: some View {
        NavigationStack {
            List {
                Group {
                    if let currentLocation {
                        CityRowView(city: currentLocation)
                            .onTapGesture {
                                selectedCity = currentLocation
                                dismiss()
                            }
                    }
                    ForEach(City.cities) { city in
                        CityRowView(city: city)
                            .onTapGesture {
                                selectedCity = city
                                dismiss()
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .listRowInsets(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
            }
            .listStyle(.plain)
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
}
