//
//  AppModel+CLLocationManagerDelegate.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import CoreLocation

extension AppModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let message = "didEnterRegion: \(region.identifier)"
        triggerNotification(message)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let message = "didExitRegion: \(region.identifier)"
        triggerNotification(message)
    }
}
