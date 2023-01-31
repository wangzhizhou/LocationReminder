//
//  AppModel.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//
import Foundation
import MapKit

class AppModel: NSObject, ObservableObject {
    
    @Published var displayRegion: MKCoordinateRegion?
    @Published var userTrackModel: MKUserTrackingMode = .follow
    @Published var showUserLocation: Bool = true
    @Published var mapType: MapType = .standard
    @Published var showAlert: Bool = false
    var userLocation: MKUserLocation?
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
        guard let coordinate = userLocation?.coordinate
        else {
            return
        }
        displayRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
    }
}

extension AppModel {
    
    func showCurrentUserLocation() {
        guard let location = userLocation?.location?.coordinate
        else {
            return
        }
        alertMessage = "\(location.latitude), \(location.longitude)"
        UIPasteboard.general.string = alertMessage
    }
}
