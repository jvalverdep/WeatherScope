//
//  ForecastHourly.swift
//  WeatherScope WatchKit Extension
//
//  Created by Javier Valverde on 7/6/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForecastHourly {
    var dateTime: String
    var weatherIcon: Int
    var temperature: Temperature
    init(dateTime: String, weatherIcon: Int, temperature: Temperature) {
        self.dateTime = dateTime
        self.weatherIcon = weatherIcon
        self.temperature = temperature
    }
    
    public static func from(jsonForecastHourly: JSON) -> ForecastHourly {
        return ForecastHourly.init(dateTime: jsonForecastHourly["DateTime"].stringValue,
                                   weatherIcon: jsonForecastHourly["WeatherIcon"].intValue,
                                   temperature: Temperature.from(jsonTemperature: jsonForecastHourly["Temperature"]))
    }
    
    public static func from(jsonForecastsHourly: [JSON]) -> [ForecastHourly] {
        var forecastHourlies = [ForecastHourly]()
        let count = jsonForecastsHourly.count
        for i in 0..<count {
            forecastHourlies.append(ForecastHourly.from(jsonForecastHourly: jsonForecastsHourly[i]))
        }
        return forecastHourlies
    }
    
    func toString() -> String {
        return "ForecastHourly -> dateTime: \(dateTime), weatherIcon: \(weatherIcon), temperature: { value: \(temperature.value), unit: \(temperature.unit)}"
    }
}
