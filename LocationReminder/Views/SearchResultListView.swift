//
//  SearchResultListView.swift
//  LocationReminder
//
//  Created by joker on 2023/2/1.
//

import SwiftUI
import MapKit

struct SearchResultListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var appModel: AppModel
    
    @Binding var searchKeyword: String
    
    @Binding var searchResults: [MKMapItem]
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 44)
            
            Text("\"\(searchKeyword)\" 搜索结果")
            
            List {
                ForEach(searchResults, id: \.self) { item in
                    Button {
                        if let region = item.placemark.location?.coordinate.mkCoordianteRegion() {
                            appModel.displayRegion = region
                            dismiss()
                        }
                    } label: {
                        Text(item.name ?? "")
                    }
                }
            }
        }
    }
}

struct SearchResultListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultListView(searchKeyword: .constant("天宫院"), searchResults: .constant([]))
    }
}
