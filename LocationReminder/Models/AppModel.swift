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
    @Published var userLocation: MKUserLocation?
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
