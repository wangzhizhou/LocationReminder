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
    
    @Binding var region: MKCoordinateRegion
    
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @Binding var showUserLocation: Bool
    
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.userTrackingMode = userTrackingMode
        mapView.showsUserLocation = showUserLocation
        context.coordinator.uiMKMapView = mapView
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.region = region
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
    }
}

struct MapView_Previews: PreviewProvider {
    
    @ObservedObject static var appModel = AppModel()
    
    static var previews: some View {
        MapView(region: $appModel.displayRegion,
                userTrackingMode: $appModel.userTrackModel,
                showUserLocation: $appModel.showUserLocation
        ).environmentObject(appModel)
    }
}
