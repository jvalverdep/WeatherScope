//
//  AccuWeatherApiService.swift
//  WeatherScope
//
//  Created by Javier Valverde on 6/23/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation

class AccuWeatherApiService {
    public static let url = "http://dataservice.accuweather.com"
    public static let forecastUrl =  "\(url)/forecasts/v1/daily/1day" // /{locationKey} 264120
    public static let geopositionSearchUrl = "\(url)/locations/v1/cities/geoposition/search" // ?q=""
}
