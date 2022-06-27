//
//  WeatherInfo.swift
//  WorkSpace
//
//  Created by JHMB on 2022/06/23.
//

import Foundation

enum WeatherType: String {
    case clear = "Clear"
    case rain = "Rain"
    case cloud = "Clouds"
    case snow = "Snow"
    case cloudSunny
}

struct WeatherInfo: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Sys: Codable {
    let country: String
}

struct ErrorMessage: Codable {
    let message: String
}
    
