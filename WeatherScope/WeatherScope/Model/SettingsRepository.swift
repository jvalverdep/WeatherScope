//
//  SettingsRepository.swift
//  WeatherScope
//
//  Created by Javier Valverde on 6/23/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation

class SettingsRepository {
    public static var accuWeatherApiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "AccuWeatherApiKey") as! String
    }
}
