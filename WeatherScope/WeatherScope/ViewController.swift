//
//  ViewController.swift
//  WeatherScope
//
//  Created by Javier Valverde on 6/23/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity

class ViewController: UIViewController {

    // Location Tracking
//    var locationManager: CLLocationManager = CLLocationManager()
//    var startLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
//        setupLocationTracking()
        
//        startWhenInUseUpdating()
//        startAlwaysUpdating()
    }
    
//    func setupLocationTracking() {
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.delegate = self
//        self.startLocation = nil
//    }
//
//    func startWhenInUseUpdating() {
//        if !(CLLocationManager.authorizationStatus() == .authorizedAlways ||
//            CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
//            locationManager.requestWhenInUseAuthorization()
//        }
//        locationManager.allowsBackgroundLocationUpdates = false
//        locationManager.pausesLocationUpdatesAutomatically = true
//        locationManager.startUpdatingLocation()
//    }
    
//    func startAlwaysUpdating() {
//        if !(CLLocationManager.authorizationStatus() == .authorizedAlways) {
//            locationManager.requestAlwaysAuthorization()
//        }
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.pausesLocationUpdatesAutomatically = true
//        locationManager.startUpdatingLocation()
//    }
}

extension ViewController:
//    CLLocationManagerDelegate,
WCSessionDelegate
{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let lastLocation = locations[locations.count - 1]
////        updateLocationInformation(forLocation: lastLocation)
//        print("Latitude: \(lastLocation.coordinate.latitude) Longitude: \(lastLocation.coordinate.longitude)")
//    }
//
//    func updateLocationInformation(forLocation location: CLLocation) {
//        let latitudValue = friendlyFormat(forValue: location.coordinate.latitude)
//        let longitudeValue = friendlyFormat(forValue: location.coordinate.longitude)
//        print(latitudValue, longitudeValue)
////        if WCSession.default.isReachable {
////            let message = ["latitud" : latitudValue, "longitud": longitudeValue]
////            WCSession.default.sendMessage(
////                message,
////                replyHandler: nil,
////                errorHandler: { error in
////                    print("Phone Error when sending message: \(error.localizedDescription)")
////            })
////
////        }
//    }
    
//    func friendlyFormat(forValue value: Double) -> String {
//        return String(format: "%.4f", value)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("LocationSample Error: \(error.localizedDescription)")
//    }
    
    
    
    
    
    // WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Phone: Activation completed with State \(activationState.rawValue)")

    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Phone: Session did become inactive")

    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Phone: Session did deactivate")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            print("Phone: Message received")
            //            self.updateView(with: (message["Response"] as? String)!)
        }

    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("Phone: Message received")
            //            self.updateView(with: (message["Response"] as? String)!)
        }
    }
    
}
