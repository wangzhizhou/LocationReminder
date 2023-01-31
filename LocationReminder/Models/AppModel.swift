//
//  AppModel.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//
import Foundation
import MapKit

class AppModel: NSObject, ObservableObject {
    
    @Published var displayRegion: MKCoordinateRegion? = .init()
    @Published var userTrackModel: MKUserTrackingMode = .follow
    @Published var showUserLocation: Bool = true
    @Published var showAlert: Bool = false
    /// 中国区为 GCJ-02 坐标
    var userMKLocation: MKUserLocation?
    /// WGS-84 坐标
    var userGPSLocation: CLLocation?
    var alertMessage: String? { didSet { showAlert = alertMessage != nil } }
    
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
    
    private let monitorRegions: [CLRegion] = [
        tianGongYuan,
        home,
    ]
    
    func startWork() {
        startMonitorRegion()
        locationManager.startUpdatingLocation()
    }
    
    func stopWork() {
        stopMonitorRegion()
        locationManager.stopUpdatingLocation()
    }
    
    func startMonitorRegion() {
        monitorRegions.forEach { locationManager.startMonitoring(for: $0) }
    }
    
    func stopMonitorRegion() {
        locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
    }
    
    func locateCurrentUser() {
        guard let coordinate = userMKLocation?.coordinate
        else {
            return
        }
        displayRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
    }
}

extension AppModel {
    
    func showCurrentUserGPSLocation() {
        guard let gpsLocation = userGPSLocation?.coordinate, let mkLocation = userMKLocation?.coordinate
        else {
            return
        }
        alertMessage = """
GPS: \(gpsLocation.latitude), \(gpsLocation.longitude)
MK : \(mkLocation.latitude), \(mkLocation.longitude)
"""
        UIPasteboard.general.string = alertMessage
    }
}
