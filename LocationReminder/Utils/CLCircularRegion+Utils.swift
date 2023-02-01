//
//  CLCircularRegion+Utils.swift
//  LocationReminder
//
//  Created by joker on 2023/1/30.
//

import MapKit

extension CLCircularRegion {
    
    var mkCoordianteRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: self.center, latitudinalMeters: self.radius, longitudinalMeters: self.radius)
    }
}
