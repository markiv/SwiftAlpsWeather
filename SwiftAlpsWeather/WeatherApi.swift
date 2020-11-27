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
    static let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/")!
    static let apiKey = "d37a967cdb5e2524a297ea5a2339efd0" // especially for Swift Alps

//   Example URL https://api.openweathermap.org/data/2.5/group?units=metric&id=6295494,785842,2950158,2761369,292223,1880252,292968,792578,863883,3042030,2772400,2867714&appid=d37a967cdb5e2524a297ea5a2339efd0

    static func group(ids: [String]) -> URL {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            fatalError("Bad URL!")
        }
        components.path.append("group")
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: "appid", value: apiKey))
        items.append(URLQueryItem(name: "units", value: "metric"))
        items.append(URLQueryItem(name: "id", value: ids.joined(separator: ",")))
        components.queryItems = items
        return components.url!
    }
}
