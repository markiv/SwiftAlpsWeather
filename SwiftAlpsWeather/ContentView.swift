//
//  ContentView.swift
//  SwiftAlpsWeather
//
//  Created by Vikram Kriplaney on 27.11.20.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                Text(city.name).bold()
                Spacer()
                Text("\(city.main.temp, specifier: "%.1f")°C")
            }
            .onAppear {
                viewModel.fetch()
            }
            .navigationTitle("Swift Alps Weather")
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var cities: [City] = []

        var cancellable: AnyCancellable?

        func fetch() {
            let ids = [
                "6295494", // Zürich
                "756135", // Warsaw
                "2950158", // Berlin
                "292223", // Dubai
                "683506", // Bucharest
                "232422", // Kampala"
                "2643743" // London
            ]
            let url = WeatherApi.group(ids: ids)

            cancellable = URLSession.shared
                .dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: CitiesResponse.self, decoder: JSONDecoder())
                .map(\.list)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        debugPrint(error)
                    }
                }, receiveValue: { cities in
                    self.cities = cities
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
