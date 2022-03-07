//
//  WeatherData.swift
//  Clima
//
//  Created by Youssef Eldeeb on 19/09/2021.
//

import Foundation

struct WeatherDataAPI: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    let description: String
    let id: Int
}
