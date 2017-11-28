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
    
    
    var result: String!
  
    func getDataFromApi () -> String{
        let jsonUrlString = "https://api.darksky.net/forecast/30f124e4a15b39ed59823c1e116b99fa/47.81009,9.63863?units=auto&lang=de&exclude=currently,minutely"
        guard let url = URL(string: jsonUrlString)else{return jsonUrlString}
        URLSession.shared.dataTask(with: url){(data, response, err) in
            guard let data = data else {return}
            let dataAsString = String(data: data, encoding: .utf8)
            self.result = dataAsString
            print(self.result)
            }.resume()
        return "OK"
    }
    
    func getDataString() -> String {
        return self.result
    }
}
