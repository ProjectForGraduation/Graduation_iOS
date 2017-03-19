//
//  LocationManager.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 19..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager!
    private var locationValue: [String: Double] = ["latitude":0.0 , "longitude":0.0]
    
    override init() {
        super.init()
        locationSetUp()
    }
    
    func locationSetUp(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getUserLocation() -> Dictionary<String, Double> {
        locationManager.startUpdatingLocation()
        return locationValue
    }
    
    func setLocationDB(_ userId:String){
        // 디비에 현재 위치를 저장한다.
        let userId = userId
        let latitude = locationValue["latitude"]
        let longitude = locationValue["longitude"]
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locationValue["latitude"] = locValue.latitude
        locationValue["longitude"] = locValue.longitude
        manager.stopUpdatingLocation()
    
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    
}
