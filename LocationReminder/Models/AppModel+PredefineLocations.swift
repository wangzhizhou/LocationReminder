//
//  AppModel+PredefineLocations.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import CoreLocation

extension AppModel {
    
    /// 天宫院
    static let tianGongYuan = CLLocationCoordinate2D(latitude: 39.67033980945019, longitude: 116.31994527297164)
        .clRegion(identifier: "tianGongYuan", radius: 200)
    
    static let home = CLLocationCoordinate2D(latitude: 39.63208038359735, longitude: 116.3086718133749)
        .clRegion(identifier: "home", radius: 20)
}
