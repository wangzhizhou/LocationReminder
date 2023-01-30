//
//  AppModel.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//
import Foundation
import MapKit

class AppModel: NSObject, ObservableObject {
    
    @Published var configuration: MKMapConfiguration = MKStandardMapConfiguration()
    @Published var displayRegion: MKCoordinateRegion = .init()
    @Published var userTrackModel: MKUserTrackingMode = .follow
    @Published var showUserLocation: Bool = true
    @Published var mapType: MapType = .standard
    var userLocation: MKUserLocation?
    
    @Published var showAlert: Bool = false
    
    var alertMessage: String? { didSet { showAlert = alertMessage != nil } }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        
        return manager
    }()
    
    func start() {
        monitorRegion()
        startWork()
    }
    
    func monitorRegion() {
        [
            Self.tianGongYuan,
            Self.home,
        ].forEach { region in
            locationManager.startMonitoring(for: region)
        }
    }
    
    func startWork() {
        locationManager.startUpdatingLocation()
    }
    
    func stopWork() {
        locationManager.stopUpdatingLocation()
    }
}

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

extension AppModel {
    
    /// 天宫院
    static let tianGongYuan = CLLocationCoordinate2D(latitude: 39.67033980945019, longitude: 116.31994527297164)
        .clRegion(identifier: "tianGongYuan", radius: 200)
    
    static let home = CLLocationCoordinate2D(latitude: 39.63208038359735, longitude: 116.3086718133749)
        .clRegion(identifier: "home", radius: 20)
}


extension CLLocationCoordinate2D {
    
    func clRegion(identifier: String, radius: CLLocationDistance) -> CLCircularRegion {
        CLCircularRegion(center: self, radius: radius, identifier: identifier)
    }
}

extension CLCircularRegion {
    var coordianteRegion: MKCoordinateRegion { MKCoordinateRegion(center: self.center, latitudinalMeters: self.radius, longitudinalMeters: self.radius) }
}
                                                                  
import UserNotifications
extension AppModel: UNUserNotificationCenterDelegate {
    
    func triggerNotification(_ message: String) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self 
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] granted, error in
            
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
