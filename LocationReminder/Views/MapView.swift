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
    
    @Binding var configuration: MKMapConfiguration
    
    @Binding var region: MKCoordinateRegion
    
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @Binding var showUserLocation: Bool
    
    @Binding var userLocation: MKUserLocation?
    
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.preferredConfiguration = configuration
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.userTrackingMode = userTrackingMode
        mapView.showsUserLocation = showUserLocation
        context.coordinator.uiMKMapView = mapView
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update MKMapView
        if uiView.userTrackingMode != appModel.userTrackModel {
            uiView.userTrackingMode = appModel.userTrackModel
        }
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
        
        func selectedLocation(tap gesture: UITapGestureRecognizer) {
            guard let uiMKMapView = self.uiMKMapView else {
                return
            }
            let location = uiMKMapView.convert(gesture.location(in: uiMKMapView), toCoordinateFrom: uiMKMapView)
            self.parent.appModel.alertMessage = "\(location.latitude), \(location.longitude)"
            UIPasteboard.general.string = self.parent.appModel.alertMessage
        }
        
        func currentLocation() {
            guard let uiMKMapView = self.uiMKMapView else {
                return
            }
            let coordinate = uiMKMapView.userLocation.coordinate
            let center = MKCoordinateRegion(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            uiMKMapView.setRegion(center, animated: true)
        }
        
        // MARK: MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.parent.appModel.userLocation = userLocation
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    @ObservedObject static var appModel = AppModel()
    
    static var previews: some View {
        MapView(configuration: $appModel.configuration,
                region: $appModel.displayRegion,
                userTrackingMode: $appModel.userTrackModel,
                showUserLocation: $appModel.showUserLocation,
                userLocation: $appModel.userLocation
        ).environmentObject(appModel)
    }
}
