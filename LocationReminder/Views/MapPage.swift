//
//  MapPage.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//

import SwiftUI
import MapKit

enum MapType: String {
    case standard = "标准"
    case imagery = "图像"
    case hybrid = "混合"
}

struct MapPage: View {
    
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        MapView(region: $appModel.displayRegion,
                userTrackingMode: $appModel.userTrackModel,
                showUserLocation: $appModel.showUserLocation,
                userLocation: $appModel.userLocation
        )
        .ignoresSafeArea()
        .alert("提示", isPresented: $appModel.showAlert) {
        } message: {
            if let alertMessage = appModel.alertMessage {
                Text(alertMessage)
            }
        }
//        .overlay(alignment: .topTrailing, content: {
//            List {
//                Picker("配置", selection: $appModel.mapType) {
//                    Text("标准").tag(MapType.standard)
//                    Text("混合").tag(MapType.hybrid)
//                    Text("图像").tag(MapType.imagery)
//                }
//            }
//        })
        .overlay(alignment: .bottomTrailing) {
            Button {
            
            } label: {
                Image(systemName: "smallcircle.filled.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .frame(width: 44, height: 44)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        }
        .overlay(alignment: .bottomLeading) {
            Button {
//                appModel.triggerNotification("test")
                appModel.showCurrentUserLocation()
            } label: {
                Text("Test")
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .padding()
        }
        .overlay(alignment: .topLeading) {
            VStack {
                
                Button {
                    if appModel.userTrackModel == .follow {
                        appModel.userTrackModel = .followWithHeading
                    } else {
                        appModel.userTrackModel = .follow
                    }
                } label: {
                    Image(systemName: appModel.userTrackModel == .follow ? "location.circle.fill" : "location.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .padding()
                
                Spacer()

            }
            .frame(width: 50, height: 150)
            .background(.white.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(EdgeInsets(top: 44, leading: 5, bottom: 0, trailing: 0))
        }
        .onAppear {
            appModel.monitorRegion()
            appModel.startWork()
        }
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage()
            .environmentObject(AppModel())
    }
}
