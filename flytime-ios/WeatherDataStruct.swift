//
//  WeatherDataStruct.swift
//  flytime-ios
//
//  Created by KOENIG on 28.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let latitude: Double
    let longitude: Double
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
}
struct Currently: Decodable {
    let time: Int!
    let summary: String!
    let icon: String!
    let nearestStormDistance: Double!
    let nearestStormBearing: Int!
    let temperature: Double!
    let windSpeed: Double!
    let windGust: Double!
    let windGustTime: Int!
    let precipType: String!
    let precipProbabilitiy: Double!
    let visibility: Double!
}
struct Hourly: Decodable {
    let summary: String
    let icon: String
    let data: [Data]
}

struct Daily: Decodable {
    let summary: String
    let icon: String
    let data: [Data]
}
struct Data: Decodable {
    let time: Int!
    let summary: String!
    let icon: String!
    let sunriseTime: Int!
    let sunsetTime: Int!
    let precipType: String!
    let precipProbability: Double!
    let windSpeed: Double!
    let windGust: Double!
    let windGustTime: Int!
    let visibility: Double!
    let temperatureMin: Double!
    let temperatureMax: Double!
    let temperature: Double!
}
