//
//  FlickerApiModel.swift
//  FlickerDemo_SwiftUI
//
//  Created by Shashikant's_Macmini on 05/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

enum LoadableState<T> {
    case loading
    case fetched(Result<T>)
}

final class FlickerListingModel: ObservableObject {
    
    required init() {
        getData()
    }
    
    var intPage = 1
    var strSearch = "Nature"
    var state: LoadableState<[FlickrPhoto]> = .loading
    @Published var arrPhotos = [FlickrPhoto]()
    
    // MARK:- WebService
    func getData() {
        Constants.getListingfor(self.strSearch, intPage: intPage) { (result) in
            switch result {
            case .success(let obj):
                if self.intPage == 1 {
                    self.arrPhotos = obj.photos?.photo ?? []
                } else {
                    self.arrPhotos.append(contentsOf: obj.photos?.photo ?? [])
                }
                self.state = .fetched(.success(obj.photos?.photo ?? []))
            case .error(let err):
                self.arrPhotos = []
                self.state = .fetched(.error(err))
            }
        }
    }
}
