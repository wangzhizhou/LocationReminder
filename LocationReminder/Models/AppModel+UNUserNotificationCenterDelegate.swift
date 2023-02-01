//
//  AppModel+UNUserNotificationCenterDelegate.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import UserNotifications
import CoreLocation

extension AppModel {
    
    func clearAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// 触发位置区域通知
    func triggerLocationNotification(regions: [CLCircularRegion], repeats: Bool = true) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        requestNotificationPermission(notificationCenter: notificationCenter) { [weak self] granted, error in
            
            if let error = error {
                self?.alertMessage = error.localizedDescription
                return
            }
            
            // Enable or disable features based on the authorization.
            guard granted else {
                return
            }
            // Build notification content
            regions.forEach { region in
                
                let regionName = region.identifier.components(separatedBy: "-").first ?? "未知区域"
                
                // 配置进入区域通知
                let enterRegionContent = UNMutableNotificationContent()
                enterRegionContent.title = "进入区域"
                enterRegionContent.body = regionName
                enterRegionContent.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 1)
                
                let enterRegionIdentifier = "enterRegion:\(region.identifier)"
                let enterRegion = CLCircularRegion(center: region.center, radius: region.radius, identifier:enterRegionIdentifier)
                enterRegion.notifyOnEntry = true
                enterRegion.notifyOnExit = false
                let enterRegionTrigger = UNLocationNotificationTrigger(region: enterRegion, repeats: repeats)
                let enterRegionRequest = UNNotificationRequest(identifier: enterRegionIdentifier,
                                                               content: enterRegionContent,
                                                               trigger: enterRegionTrigger)
                
                notificationCenter.add(enterRegionRequest) { error in
                    // 暂不处理结果
                    print("regions: \(enterRegionIdentifier)")
                }
                
                // 配置离开区域通知
                let exitRegionContent = UNMutableNotificationContent()
                exitRegionContent.title = "离开区域"
                exitRegionContent.body = regionName
                exitRegionContent.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 1)
                
                let exitRegionIdentifier = "exitRegion:\(region.identifier)"
                let exitRegion = CLCircularRegion(center: region.center, radius: region.radius, identifier:exitRegionIdentifier)
                exitRegion.notifyOnEntry = false
                exitRegion.notifyOnExit = true
                let exitRegionTrigger = UNLocationNotificationTrigger(region: exitRegion, repeats: repeats)
                let exitRegionRequest = UNNotificationRequest(identifier: exitRegionIdentifier,
                                                              content: exitRegionContent,
                                                              trigger: exitRegionTrigger)
                
                notificationCenter.add(exitRegionRequest) { error in
                    // 暂不处理结果
                    print("regions: \(exitRegionIdentifier)")
                }
            }
        }
    }
    
    func requestNotificationPermission(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current(), completionHandler: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: completionHandler)
    }
}

extension AppModel: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner, .list])
    }
}
