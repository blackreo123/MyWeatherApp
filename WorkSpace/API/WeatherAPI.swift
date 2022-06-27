//
//  WeatherAPI.swift
//  WorkSpace
//
//  Created by JHMB on 2022/06/23.
//

import Foundation

class WeatherAPI: NSObject {
    func getCurrentWeather(lat: Double, lon: Double, success: @escaping(WeatherInfo) -> (), failure: @escaping(ErrorMessage) -> ()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=e87030286b1c3f117a94760cdd449a62"
        ) else {return}
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, respons, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            if let respons = respons as? HTTPURLResponse, successRange.contains(respons.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInfo.self, from: data) else {return}
                success(weatherInformation)
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else {return}
                failure(errorMessage)
            }
        }.resume()
    }
}


