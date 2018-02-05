//
//  DataHanderClass.swift
//  flytime-ios
//
//  Created by FRICK ; KOENIG on 23.11.17.
//
//Fetches and Stores the Data
// TODO not yet full REST, CoreDAta, ...
//
// API CALL OVER SERVER, server must be Online,
// API CAALL OVER DARKSKY, needs USERKEY

import Foundation
import UIKit

class DataHandler {
    var weatherData: WeatherData!
    var sunriseTimeToday: Int!
    var sunriseTimeTomorrow: Int!
    var sunsetTimeToday: Int!
    var sunsetTimeTomorrow: Int!

    func getDataFromApi (latitude: Double, longitude: Double) {
        var jsonUrlString = "https://api.darksky.net/forecast/USERKEY/"
            jsonUrlString.append(String(latitude))
            jsonUrlString.append(",")
            jsonUrlString.append(String(longitude))
        jsonUrlString.append("?units=auto&lang=de&exclude=minutely")
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
