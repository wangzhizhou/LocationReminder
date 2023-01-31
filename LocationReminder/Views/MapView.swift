//
//  MapView.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject private var appModel: AppModel
    
    @Binding var displayRegion: MKCoordinateRegion
    
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @Binding var showUserLocation: Bool
    
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = userTrackingMode
        mapView.showsUserLocation = showUserLocation
        context.coordinator.uiMKMapView = mapView
        
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.selectedLocation(tap:)))
//        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.region = displayRegion
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        weak var uiMKMapView: MKMapView?
        
        init(parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.parent.appModel.userMKLocation = userLocation
        }
        
        @objc func selectedLocation(tap gesture: UITapGestureRecognizer) {
            guard let uiMKMapView = self.uiMKMapView else {
                return
            }
            let location = uiMKMapView.convert(gesture.location(in: uiMKMapView), toCoordinateFrom: uiMKMapView)
            self.parent.appModel.alertMessage = """
            GCJ-20: \(location.latitude), \(location.longitude)
            WGS-84: \(location.gcj2wgs.latitude), \(location.gcj2wgs.longitude)
            """
            UIPasteboard.general.string = self.parent.appModel.alertMessage
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    @ObservedObject static var appModel = AppModel()
    
    static var previews: some View {
        MapView(displayRegion: $appModel.displayRegion,
                userTrackingMode: $appModel.userTrackModel,
                showUserLocation: $appModel.showUserLocation
        ).environmentObject(appModel)
    }
}
