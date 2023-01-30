//
//  AppModel+UNUserNotificationCenterDelegate.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import UserNotifications

extension AppModel: UNUserNotificationCenterDelegate {
    
    func requestNotificationPermission(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current(), completionHandler: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: completionHandler)
    }
    
    func triggerNotification(_ message: String) {
        
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
            let content = UNMutableNotificationContent()
            content.title = "区域事件提醒"
            content.body = message
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 1)
            
            // Create a trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            // Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                                                content: content, trigger: trigger)
            
            // Schedule the request with the system.
            notificationCenter.add(request) { (error) in
                if error != nil {
                    // Handle any errors.
                }
            }
        }
    }
    
    // MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner, .list])
    }
}
