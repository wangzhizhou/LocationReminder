//
//  CLLocationCoordinate2D+Utils.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    func clRegion(identifier: String, radius: CLLocationDistance) -> CLCircularRegion {
        CLCircularRegion(center: self, radius: radius, identifier: identifier)
    }
    
    var gcj2wgs: CLLocationCoordinate2D {
        let (wgsLat, wgsLon) = LocationTransform.gcj2wgs(gcjLat: latitude, gcjLng: longitude)
        return CLLocationCoordinate2D(latitude: wgsLat, longitude: wgsLon)
    }
    
    var wgs2gcj: CLLocationCoordinate2D {
        let (gcjLat, gcjLon) = LocationTransform.wgs2gcj(wgsLat: latitude, wgsLng: longitude)
        return CLLocationCoordinate2D(latitude: gcjLat, longitude: gcjLon)
    }
}
