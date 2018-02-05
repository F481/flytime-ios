//
//  WeatherDataStruct.swift
//  flytime-ios
//
//  Created by FRICK ; KOENIG on 23.11.17.
//
// Struct for the Weather Data
// Codable for JSON Parsing

import Foundation
import Charts
struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
}
struct Currently: Codable {
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
struct Hourly: Codable {
    let summary: String
    let icon: String
    let data: [Data]
}

struct Daily: Codable {
    let summary: String
    let icon: String
    let data: [Data]
}
struct Data: Codable {
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
struct Result {
    let countBestFlyTime: Int
    let firstEntry: ChartDataEntry
    let secondEntry: ChartDataEntry
}
