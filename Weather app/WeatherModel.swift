//
//  WeatherModel.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 06/10/23.
//

import Foundation

struct CurrentResponse: Decodable {
    
    var location: Location
    var current: Current
   
}

struct ForecastResponse: Decodable {
    
    var location: Location
    var current: Current
    var forecast: Forecast
}

struct Location: Decodable {
    
    var name: String?
    var region: String?
    var country: String?
    var lat: Double?
    var lon: Double?
    var tz_id: String?
    var localtime_epoch: Int?
    var localtime: String?
}

struct Current: Decodable {
    
    var temp_c: Double
    var wind_kph: Double
    var wind_mph: Double
    var humidity: Double
    var pressure_in: Double
    var condition: Condition
    
}

struct Condition: Decodable {
    var text: String
    var icon: String
    var code: Int
}

struct Forecast: Decodable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {

    var date: String
    var date_epoch: Double
    var day: Day
    var hour: [Hour]
}

struct Hour: Decodable {

    var time: String
    var temp_c: Double
    var condition: Condition
}

struct Day: Decodable {
    
    var condition: Condition
    var maxtemp_c: Double
    var mintemp_c: Double
    var avgtemp_c: Double 
    
}
