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
                displayRegion = coordinate.mkCoordianteRegion
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
        mudanyuan,
        xingong,
        tianGongYuan,
        home,
        company,
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
        stopMonitorRegion()
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
        displayRegion = coordinate.mkCoordianteRegion
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
}
