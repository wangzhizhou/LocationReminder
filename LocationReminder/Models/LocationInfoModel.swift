//
//  LocationInfoModel.swift
//  LocationReminder
//
//  Created by joker on 2023/2/1.
//

import CoreLocation

struct LocationInfoModel: Identifiable {
    
    /// 名称
    let name: String
    
    /// WGS-84 坐标纬度
    let wgsLatitude: CLLocationDegrees
    
    /// WGS-84 坐标经度
    let wgsLongitude: CLLocationDegrees
    
    /// 唯一标识符
    var id: String { "\(name)-(\(wgsLatitude),\(wgsLongitude))" }
}

extension LocationInfoModel {
    
    /// WGS-84 地球坐标经纬度
    var wgsLocationCoordinate2D: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: wgsLatitude, longitude: wgsLongitude) }
    
    
    /// GCJ-02 火星坐标经纬度，用在谷歌地图，高德地图等中国地图服务，百度地图要在GCJ-02基础上再加转换
    var gcjLocationCoordinate2D: CLLocationCoordinate2D {
        let (gcjLat, gcjLon) = LocationTransform.wgs2gcj(wgsLat: wgsLatitude, wgsLng: wgsLongitude)
        return CLLocationCoordinate2D(latitude: gcjLat, longitude: gcjLon)
    }
    
    /// 百度地图经纬度
    var bdLocationCoordinate2D: CLLocationCoordinate2D {
        let (bdLat, bdLon) = LocationTransform.wgs2bd(wgsLat: wgsLatitude, wgsLng: wgsLongitude)
        return CLLocationCoordinate2D(latitude: bdLat, longitude: bdLon)
    }
    
}

extension LocationInfoModel {
    
    func wgsCLCircularRegion(radius: CLLocationDistance) -> CLCircularRegion {
        return wgsLocationCoordinate2D.clCircularRegion(identifier: id, radius: radius)
        
    }
}
