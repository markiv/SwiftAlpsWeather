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
        List(viewModel.cities) { city in
            Text(city.name)
        }.onAppear {
            viewModel.fetch()
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var cities: [City] = []

        var cancellable: AnyCancellable?

        func fetch() {
            let ids = [
                "6295494",
                "785842",
                "2950158",
                "2761369",
                "292223",
                "1880252",
                "292968",
                "792578",
                "863883",
                "3042030",
                "2772400",
                "2867714"
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
