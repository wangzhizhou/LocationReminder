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
}
