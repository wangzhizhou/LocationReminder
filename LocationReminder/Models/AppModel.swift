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
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        
        manager.requestAlwaysAuthorization()
        
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
