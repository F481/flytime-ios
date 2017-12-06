//
//  File.swift
//  flytime-ios
//
//  Created by KOENIG on 28.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
// http://84.128.118.79/getWeatherData.php?lat=47.81008&lng=9.63863 -> WeatherAPICall

import Foundation
import UIKit

class DataHandler {
    var weatherData: WeatherData!
    var sunriseTimeToday: Int!
    var sunriseTimeTomorrow: Int!
    var sunsetTimeToday: Int!
    var sunsetTimeTomorrow: Int!

    func getDataFromApi (latitude: Double, longitude: Double) {
        var jsonUrlString = "http://84.128.118.79/getWeatherData.php?lat="
            jsonUrlString.append(String(latitude))
            jsonUrlString.append("&lng=")
            jsonUrlString.append(String(longitude))
        guard  let url = URL(string: jsonUrlString) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) {(data, _, _) in
            guard let data = data else { return }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                self.sunriseTimeToday = self.weatherData.daily.data[0].sunriseTime-3600
                self.sunsetTimeToday = self.weatherData.daily.data[0].sunsetTime+3600
                self.sunriseTimeTomorrow = self.weatherData.daily.data[1].sunriseTime-3600
                self.sunsetTimeTomorrow = self.weatherData.daily.data[1].sunsetTime+3600
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getWeatherData() -> WeatherData! {
        return self.weatherData
    }
}
