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
    func getDataFromApi () {
        let jsonUrlString = "https://api.darksky.net/forecast/30f124e4a15b39ed59823c1e116b99fa/47.81009,9.63863?units=auto&lang=de&exclude=currently,minutely"
        guard  let url = URL(string: jsonUrlString) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) {(data, _, _) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                
            }
        }
        task.resume()
    }
    
    func getDataString() -> String {
        return self.result
    }
}
