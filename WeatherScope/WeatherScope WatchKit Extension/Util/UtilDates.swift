//
//  UtilDates.swift
//  WeatherScope WatchKit Extension
//
//  Created by Javier Valverde on 7/6/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation

class UtilDates {
    
    static func getDate(stringDate: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: stringDate)
    }
    
    static func getHour(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date)
    }
    
    static func spanishFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date).replacingOccurrences(of: "-", with: "/")
    }
    
}
