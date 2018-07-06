//
//  Temperature.swift
//  WeatherScope WatchKit Extension
//
//  Created by Javier Valverde on 7/6/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Temperature {
    var value: Double
    var unit: String
    
    init(value: Double, unit: String) {
        self.value = value
        self.unit = unit
    }
    
    public static func from(jsonTemperature: JSON) -> Temperature{
        return Temperature.init(value: jsonTemperature["Value"].doubleValue, unit: jsonTemperature["Unit"].stringValue)
    }
}
