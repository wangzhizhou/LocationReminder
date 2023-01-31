//
//  AppModel+PredefineLocations.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import CoreLocation

extension AppModel {
    
    /// 牡丹园地铁站
    static let mudanyuan = CLLocationCoordinate2D(latitude: 39.97499566704194, longitude: 116.36382631553451)
        .clRegion(identifier: "牡丹园地铁站", radius: 250)
    
    /// 新宫地铁站
    static let xingong = CLLocationCoordinate2D(latitude: 39.81094278397138, longitude: 116.35943411894893)
        .clRegion(identifier: "新宫地铁站", radius: 250)
    
    /// 天宫院地铁站
    static let tianGongYuan = CLLocationCoordinate2D(latitude: 39.669054801177865, longitude: 116.31388140652918)
        .clRegion(identifier: "天宫院地铁站", radius: 250)
    
    /// 大兴区家
    static let home = CLLocationCoordinate2D(latitude: 39.630645919287836, longitude: 116.30278513822583)
        .clRegion(identifier: "家", radius: 50)
    
    /// 海淀区公司
    static let company = CLLocationCoordinate2D(latitude: 39.97824350429831, longitude: 116.36265953860611)
        .clRegion(identifier: "公司", radius: 50)
}
