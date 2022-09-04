//
//  LocationPermission.swift
//  Chores for me
//
//  Created by Arzoo Mac on 11/11/21.
//

import Foundation
import UIKit
import CoreLocation

public class LocationPermission :NSObject {
    var location_manager = CLLocationManager()
    
    func CheckLocationPermision() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                print("---------- Got Access---------")
                return true
            case .notDetermined, .restricted, .denied:
                //showPermissionAlert()
                print("---------- User denied Access---------")
                return false
            default:
                return false
            }
        } else {
            return false
        }
        
    }
    
}
