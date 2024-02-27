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


import SwiftUI
import MapKit

struct SearchOverlay: View {
    @Binding var isSearching: Bool
    @Environment(DataStore.self) private var store
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    @State private var searchService = SearchService(completer: MKLocalSearchCompleter())
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                    Button {
                        withAnimation {
                            isSearching = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .padding()
                List(searchService.cities) { city in
                    Button {
                        store.cities.append(city)
                        store.saveCities()
                        isSearching = false
                    } label: {
                        Text(city.name)
                            .font(.headline)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onChange(of: searchText) {
            searchService.update(queryFragment: searchText)
        }
        .onAppear {
            searchService.cities = []
            isFocused = true
            searchText = ""
        }
    }
}

#Preview {
    SearchOverlay(isSearching: .constant(true))
        .environment(DataStore(forPreviews: true))
}
