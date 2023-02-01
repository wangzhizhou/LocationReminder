//
//  AppModel.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//
import Foundation
import MapKit

class AppModel: NSObject, ObservableObject {
    
    @Published var displayRegion: MKCoordinateRegion = .init()
    @Published var userTrackModel: MKUserTrackingMode = .follow
    @Published var showUserLocation: Bool = true
    @Published var showAlert: Bool = false
    /// 中国区为 GCJ-02 坐标
    /// 参考： https://abstractkitchen.com/blog/a-short-guide-to-chinese-coordinate-system/
    var userMKLocation: MKUserLocation? {
        willSet {
            if userMKLocation == nil, newValue != nil, let coordinate = newValue?.coordinate {
                displayRegion = coordinate.mkCoordianteRegion()
            }
        }
    }
    /// WGS-84 坐标
    var userWGSCoordinate: CLLocationCoordinate2D? {
        guard let userLocationCoordinate = userMKLocation?.location?.coordinate
        else {
            return nil
        }
        return userLocationCoordinate.gcj2wgs
    }
    
    var alertMessage: String? {
        didSet {
            if Thread.current.isMainThread {
                showAlert = alertMessage != nil
            } else {
                DispatchQueue.main.async {
                    self.showAlert = self.alertMessage != nil
                }
            }
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.showsBackgroundLocationIndicator = true
        manager.delegate = self
        return manager
    }()
    
    func startWork() {
        locationManager.startUpdatingLocation()
    }
    
    func stopWork() {
        locationManager.stopUpdatingLocation()
    }
}

extension AppModel {
    
    func showCurrentUserGPSLocation() {
        guard let wgsCoordinate = userWGSCoordinate , let mkLocation = userMKLocation?.coordinate
        else {
            return
        }
        alertMessage = """
WGS-84: \(wgsCoordinate.latitude), \(wgsCoordinate.longitude)
GCJ-02: \(mkLocation.latitude), \(mkLocation.longitude)
"""
        UIPasteboard.general.string = alertMessage
    }
    
    func locateCurrentUser() {
        guard let coordinate = userMKLocation?.coordinate
        else {
            return
        }
        displayRegion = coordinate.mkCoordianteRegion()
    }
    
    func setupMonitorRegions() {
        showAllPendingNotificationRequest()
        clearAllPendingNotificationRequests()
        requestNotificationPermission { granted, error in
            guard granted
            else {
                self.alertMessage = "需要授权推送，才能接收到位置提醒"
                return
            }
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let pendingRequestIds = requests.map { $0.identifier }
                let regions = LocationInfoModel.monitorCircularRegions.filter { region in
                    return !pendingRequestIds.contains(region.identifier)
                }
                self.triggerLocationNotification(regions: regions)
            }
        }
    }
    
    func showAllPendingNotificationRequest() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            requests.forEach { request in
                print(request.identifier)
            }
        }
    }
}
