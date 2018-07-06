//
//  InterfaceController.swift
//  WeatherScope WatchKit Extension
//
//  Created by Javier Valverde on 6/23/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import Alamofire
import SwiftyJSON
import CoreLocation

class InterfaceController: WKInterfaceController {

    
    @IBOutlet var weatherIcon: WKInterfaceImage!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    
    // Location Tracking
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation?
    
    var currentIndex = 0
    var forecastHourlies: [ForecastHourly] = []
    var forecastHourly: ForecastHourly?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupLocationTracking()
        startWhenInUseUpdating()
    }
    
    override func willActivate() {
        super.willActivate()
//         Verifiy is Session is supported
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
//    func updateView(with text: String) {
//        WKInterfaceDevice().play(.click)
//        messageLabel.setText(text)
//    }
    
    func setupLocationTracking() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.startLocation = nil
    }

    func startWhenInUseUpdating() {
        if !(CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(InterfaceController.updateLocationJustOnce), userInfo: nil, repeats: true)
    }
    @objc func updateLocationJustOnce()
    {
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
    }
    
    
}

extension InterfaceController:
    CLLocationManagerDelegate,
    WCSessionDelegate
{
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[locations.count - 1]
        //        updateLocationInformation(forLocation: lastLocation)
        print("Latitude: \(lastLocation.coordinate.latitude) Longitude: \(lastLocation.coordinate.longitude)")
        getLocationKey(withLatitude: "\(lastLocation.coordinate.latitude)", withLongitude: "\(lastLocation.coordinate.longitude)")
        
    }

    func updateLocationInformation(forLocation location: CLLocation) {
        let latitudValue = friendlyFormat(forValue: location.coordinate.latitude)
        let longitudeValue = friendlyFormat(forValue: location.coordinate.longitude)
        print(latitudValue, longitudeValue)
        //        if WCSession.default.isReachable {
        //            let message = ["latitud" : latitudValue, "longitud": longitudeValue]
        //            WCSession.default.sendMessage(
        //                message,
        //                replyHandler: nil,
        //                errorHandler: { error in
        //                    print("Phone Error when sending message: \(error.localizedDescription)")
        //            })
        //
        //        }
        
    }

    func friendlyFormat(forValue value: Double) -> String {
        return String(format: "%.4f", value)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationSample Error: \(error.localizedDescription)")
    }

    func getLocationKey(withLatitude latitude: String, withLongitude longitude: String) {
        let qParameter = "\(latitude),\(longitude)"
        let parameters = ["apikey": SettingsRepository.accuWeatherApiKey, "q": qParameter, "language": "en-us", "details": "false", "toplevel": "false"]
        var locationKey = ""
        Alamofire.request("\(AccuWeatherApiService.geoPositionSearchUrl)", parameters: parameters).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                locationKey = json["Key"].stringValue;
                print(locationKey)
                self.getForecast(withLocationKey: locationKey)
                
            case .failure (let error):
                print("\(error)")
                return
            }
        })
    }
    
    func getForecast(withLocationKey locationKey: String) {
        let parameters = ["apikey": SettingsRepository.accuWeatherApiKey, "language": "en-us", "details": "false", "metric": "true"]
        Alamofire.request("\(AccuWeatherApiService.forecastTwelveHourHourlyUrl)/\(locationKey)", parameters: parameters).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                self.forecastHourlies = ForecastHourly.from(jsonForecastsHourly: json)
                self.currentIndex = 0
                self.forecastHourly = self.forecastHourlies[self.currentIndex]
//                print(self.forecastHourly!.toString())
                if let _ = self.forecastHourly {
                    self.updateView()
                }
                
            case .failure (let error):
                print("\(error)")
                return
            }
        })
    }
    
    func getWeatherIcon(withWeatherIcon number: Int) {
//        Alamofire.request("\(AccuWeatherApiService.weatherIconsUrl(weatherIconNumber: number))", method: .get, parameters: nil)
    }
    
    func updateView() {
        if let forecast = self.forecastHourly {
            self.temperatureLabel.setText("\(forecast.temperature.value) º\(forecast.temperature.unit)")
            self.timeLabel.setText(UtilDates.getHour(UtilDates.getDate(stringDate: forecast.dateTime)!))
        }
    }
    @IBAction func swipeLeftAction(_ sender: Any) {
        print("left")
        let count = self.forecastHourlies.count
        let maxIndex = count - 1
        self.currentIndex += 1
        if (self.currentIndex > maxIndex) {
            self.currentIndex = 0
        }
        if !self.forecastHourlies.isEmpty {
            self.forecastHourly = self.forecastHourlies[self.currentIndex]
            if let forecast = self.forecastHourly {
                self.updateView()
//                print(forecast.toString())
            }
        }
        
        
    }
    
    @IBAction func swipeRightAction(_ sender: Any) {
        print("right")
        let count = self.forecastHourlies.count
        let minIndex = 0
        let maxIndex = count - 1
        self.currentIndex -= 1
        if (self.currentIndex < minIndex) {
            self.currentIndex = maxIndex
        }
        if !self.forecastHourlies.isEmpty {
            self.forecastHourly = self.forecastHourlies[self.currentIndex]
            if let forecast = self.forecastHourly {
                self.updateView()
//                print(forecast.toString())
            }
        }
        
    }
    // WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch: Activation did complete with state \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Watch: Message received")
//        updateView(with: (message["Message"] as? String)!)
//        getLocationKey(withLatitude: (message["latitude"] as? String)!, withLongitude: (message["longitude"] as? String)!)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        updateView(with: (message["Message"] as? String)!)
//        getLocationKey(withLatitude: (message["latitude"] as? String)!, withLongitude: (message["longitude"] as? String)!)
    }
    
    
    
}
