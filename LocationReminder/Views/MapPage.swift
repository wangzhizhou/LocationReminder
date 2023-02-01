//
//  MapPage.swift
//  LocationReminder
//
//  Created by joker on 2023/1/14.
//

import SwiftUI
import MapKit

struct MapPage: View {
    
    @EnvironmentObject private var appModel: AppModel
    
    @State private var searchText: String = ""
    @State private var isPresentSearchResultList = false
    @State private var mkMapItems: [MKMapItem] = []
    
    var body: some View {
        NavigationView {
            MapView(displayRegion: $appModel.displayRegion,
                    userTrackingMode: $appModel.userTrackModel,
                    showUserLocation: $appModel.showUserLocation
            )
            .ignoresSafeArea()
            .overlay(alignment: .bottomTrailing) {
                Button {
                    appModel.locateCurrentUser()
                } label: {
                    Image(systemName: "smallcircle.filled.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .frame(width: 44, height: 44)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 5))
            }
            .statusBarHidden()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                appModel.startWork()
            }
            .fullScreenCover(isPresented: $isPresentSearchResultList) {
                SearchResultListView(searchKeyword: $searchText, searchResults: $mkMapItems)
                    .statusBarHidden()
            }
            .alert("提示", isPresented: $appModel.showAlert) {
            } message: {
                if let alertMessage = appModel.alertMessage {
                    Text(alertMessage)
                }
            }
        }
        .searchable(text: $searchText, prompt: Text("Search a Location"))
        .onSubmit(of: .search) {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = appModel.displayRegion
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response
                else {
                    return
                }
                isPresentSearchResultList = !response.mapItems.isEmpty
                self.mkMapItems = response.mapItems
            }
        }
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage()
            .environmentObject(AppModel())
    }
}
