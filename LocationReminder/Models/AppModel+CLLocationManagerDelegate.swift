//
//  AppModel+CLLocationManagerDelegate.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import CoreLocation

extension AppModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            stopWork()
            if CLLocationManager.locationServicesEnabled() {
                alertMessage = "您拒绝开启定位功能，App不能正常使用"
            } else {
                alertMessage = "定位服务不可用，App不能正常使用"
            }
        case .authorizedWhenInUse, .authorizedAlways:
            setupMonitorRegions()
        default:
            break
        }
    }
    
}
