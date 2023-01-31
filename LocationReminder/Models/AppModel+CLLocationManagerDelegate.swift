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
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            requestNotificationPermission { [weak self] granted, error in
                guard granted
                else {
                    self?.alertMessage = "需要授权推送，才能接收到位置提醒"
                    return
                }
            }
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let message = "进入区域: \(region.identifier)"
        triggerNotification(message)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let message = "离开区域: \(region.identifier)"
        triggerNotification(message)
    }
}
