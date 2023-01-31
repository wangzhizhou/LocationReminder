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
        .clRegion(identifier: "天宫院地铁站", radius: 50)
    
    static let home = CLLocationCoordinate2D(latitude: 39.63189214660146, longitude: 116.30884228511107)
        .clRegion(identifier: "家", radius: 50)
    
    static let company = CLLocationCoordinate2D(latitude: 39.97824350429831, longitude: 116.36265953860611)
        .clRegion(identifier: "公司", radius: 50)
}
