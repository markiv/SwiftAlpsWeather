//
//  ContentView.swift
//  SwiftAlpsWeather
//
//  Created by Vikram Kriplaney on 27.11.20.
//

import SwiftUI
import Combine

struct LoadingOverlay: View {
    let isLoading: Bool

    var body: some View {
        if isLoading {
            Text("Loading...")
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.black)
                        .opacity(0.5)
                )
                .transition(.scale).animation(.spring())
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
//    @StateObject var locationModel = LocationModel()

    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.secondary)
                    city.weather.first?.image
                        .renderingMode(.original)
                        .imageScale(.large)
                        .shadow(radius: 2)
                }

                Text(city.name).bold()
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(city.main.temp, specifier: "%.1f")°C")
                    HStack {
                        Text("\(city.main.tempMin, specifier: "%.1f")°C")
                            .foregroundColor(.blue)
                        Text("\(city.main.tempMax, specifier: "%.1f")°C")
                            .foregroundColor(.red)
                    }.font(.caption)
                }
            }
            .overlay(
                LoadingOverlay(isLoading: viewModel.isLoading)
            )
            .alert(isPresented: $viewModel.hasError, content: {
                Alert(title: Text(viewModel.error?.localizedDescription ?? "Error"))
            })
            .onAppear {
                viewModel.fetch()
            }.navigationTitle("Swift Alps Weather")
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var cities: [City] = []
        @Published var isLoading = false
        @Published var error: Error?
        @Published var hasError = false

        var cancellable: AnyCancellable?

        func fetch() {
            let ids = [
                "756135", // Warsaw
                "683506", // Bucharest
                "2657896", // Zürich
                "2643743", // London
                "2950159" // Berlin
            ]

            let url = WeatherApi.group(ids: ids)
            isLoading = true
            hasError = false

            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: CitiesResponse.self, decoder: JSONDecoder())
                .map(\.list)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [self] completion in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading = false
                    }
                    if case let .failure(error) = completion {
                        self.error = error
                        self.hasError = true
                    }
                }, receiveValue: { cities in
                    self.cities = cities
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()

//        ContentView()
//            .environment(\.colorScheme, .dark)

        LoadingOverlay(isLoading: true)
    }
}

extension Weather {
    var image: Image {
        switch id {
        case 200 ..< 300: return Image(systemName: "cloud.bolt.rain.fill")
        case 300 ..< 400: return Image(systemName: "cloud.drizzle.fill")
        case 500 ..< 600: return Image(systemName: "cloud.rain.fill")
        case 600 ..< 700: return Image(systemName: "cloud.snow.fill")
        case 700 ..< 800: return Image(systemName: "cloud.fog.fill")
        case 800: return Image(systemName: "sun.max.fill")
        default: return Image(systemName: "cloud.fill")
        }
    }
}
