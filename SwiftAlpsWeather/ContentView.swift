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
            let url = URL(string: "https://api.openweathermap.org/data/2.5/group?units=metric&id=6295494,785842,2950158,2761369,292223,1880252,292968,792578,863883,3042030,2772400,2867714&appid=d37a967cdb5e2524a297ea5a2339efd0")!

            cancellable = URLSession.shared
                .dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: CitiesResponse.self, decoder: JSONDecoder())
                .map(\.list)
                .receive(on: DispatchQueue.main)
                .replaceError(with: [])
                .assign(to: \.cities, on: self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
