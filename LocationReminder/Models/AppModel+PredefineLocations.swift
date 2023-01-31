//
//  AppModel+PredefineLocations.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import CoreLocation

/// 中国区为 GCJ-02 坐标
extension AppModel {
    /// 天宫院
    static let tianGongYuan = CLLocationCoordinate2D(latitude: 39.67033980945019, longitude: 116.31994527297164)
        .clRegion(identifier: "tianGongYuan", radius: 50)
    
    static let home = CLLocationCoordinate2D(latitude: 39.63189214660146, longitude: 116.30884228511107)
        .clRegion(identifier: "home", radius: 50)
    
    static let company = CLLocationCoordinate2D(latitude: 39.979600320577184, longitude: 116.36885811218218)
        .clRegion(identifier: "company", radius: 50)
}
