//
//  AccuWeatherApiService.swift
//  WeatherScope WatchKit Extension
//
//  Created by Javier Valverde on 6/23/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation

class AccuWeatherApiService {
    public static let url = "http://dataservice.accuweather.com"
    public static let geoPositionSearchUrl = "\(url)/locations/v1/cities/geoposition/search" // ?q=""
    public static let forecastTwelveHourHourlyUrl = "\(url)/forecasts/v1/hourly/12hour" // /{locationKey} 258434
    
    public static func weatherIconsUrl(weatherIconNumber: Int) -> String {
        return "https://developer.accuweather.com/sites/default/files/\(String(format: "%02d", weatherIconNumber))-s.png"
    }
}
