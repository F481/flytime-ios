//
//  File.swift
//  flytime-ios
//
//  Created by KOENIG on 28.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import Foundation
import UIKit

class DataHandler {
    var weatherData: WeatherData!
    
    func getDataFromApi (latitude: Double, longitude: Double) {
        
        var jsonUrlString = "https://api.darksky.net/forecast/30f124e4a15b39ed59823c1e116b99fa/"
            jsonUrlString.append(String(latitude))
            jsonUrlString.append(",")
            jsonUrlString.append(String(longitude))
            jsonUrlString.append("?units=auto&lang=de&exclude=currently,minutely")
        guard  let url = URL(string: jsonUrlString) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) {(data, _, _) in
            guard let data = data else { return }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getWeatherData() -> WeatherData {
        return self.weatherData
    }
}
