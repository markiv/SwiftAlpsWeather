//
//  WeatherApi.swift
//  SwiftAlpsWeather
//
//  Created by Vikram Kriplaney on 27.11.20.
//

import Foundation

/// API definition for weather data from openweathermap.org.
/// See https://openweathermap.org/api

enum WeatherApi {
    static let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5")!
    static let apiKey = "d37a967cdb5e2524a297ea5a2339efd0" // especially for Swift Alps

    static func find() -> URL {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            fatalError("Bad URL!")
        }
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: "appid", value: apiKey))
        items.append(URLQueryItem(name: "lat", value: "47.366667"))
        items.append(URLQueryItem(name: "lon", value: "8.55"))
        components.queryItems = items
        return components.url!
    }
}
