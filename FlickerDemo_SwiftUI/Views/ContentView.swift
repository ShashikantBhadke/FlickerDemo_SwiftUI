//
//  ContentView.swift
//  FlickerDemo_SwiftUI
//
//  Created by Shashikant's_Macmini on 05/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ContentView: View {
    
    init() {
        objPhotos = FlickerListingModel()
    }
    
    var searchName = ""
    @State var pushToHome = false
    @ObservedObject var objPhotos = FlickerListingModel()
    @Environment(\.presentationMode) var presentationMode
    
    private var stateContent: AnyView {
        switch objPhotos.state {
        case .loading:
            return AnyView(
                ActivityIndicator(style: .medium)
            )
        case .fetched(let result):
            switch result {
            case .error(let error):
                return AnyView(
                    Text(error)
                )
            case .success(_ ):
                return AnyView(
                    ScrollView {
                        ForEach(objPhotos.arrPhotos) { (item) -> KFImage in
                            return KFImage(URL(string: item.urlM ?? "https://github.com/onevcat/Kingfisher/blob/master/images/kingfisher-1.jpg?raw=true")!)
                                .resizable()
                        }
                    }
                )
            }
        }
    }
    
    var body: some View {
        stateContent
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
