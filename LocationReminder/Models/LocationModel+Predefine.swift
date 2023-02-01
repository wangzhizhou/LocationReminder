//
//  LocationModel+Predefine.swift
//  LocationReminder
//
//  Created by joker on 2023/2/1.
//

import CoreLocation

extension LocationInfoModel {
    
    static let mudanyuan = LocationInfoModel(
        name: "牡丹园地铁站",
        wgsLatitude: 39.97499566704194,
        wgsLongitude: 116.36382631553451
    )
    
    static let xingong = LocationInfoModel(
        name: "新宫地铁站",
        wgsLatitude: 39.81094278397138,
        wgsLongitude: 116.35943411894893
    )
    
    static let tiangongyuan = LocationInfoModel(
        name: "天宫院地铁站",
        wgsLatitude: 39.669054801177865,
        wgsLongitude: 116.31388140652918
    )
    
    static let home = LocationInfoModel(
        name: "家",
        wgsLatitude: 39.630645919287836,
        wgsLongitude: 116.30278513822583
    )
    
    static let company = LocationInfoModel(
        name: "公司",
        wgsLatitude: 39.97824350429831,
        wgsLongitude: 116.36265953860611
    )
    
    static var monitorCircularRegions: [CLCircularRegion] {
        return [
            mudanyuan.wgsCLCircularRegion(),
            xingong.wgsCLCircularRegion(),
            tiangongyuan.wgsCLCircularRegion(),
            home.wgsCLCircularRegion(),
            company.wgsCLCircularRegion(),
        ]
    }
}
