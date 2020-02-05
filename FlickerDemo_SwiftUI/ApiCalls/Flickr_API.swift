//
//  Flickr_API.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

struct Constants {
    
    struct FlickrURLParams {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
    }
    
    struct FlickrAPIKeys {
        static let SearchMethod = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let ResponseFormat = "format"
        static let DisableJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let Per_Page = "per_page"
        static let Page = "page"
    }
    
    struct FlickrAPIValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "66898d1ee15e65f635953c936c915a4c"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
        static let SafeSearch = "1"
        static let Per_Page = "30"
    }
    
    static private func flickrURLFromParameters(searchString: String, intPage: Int = 1) -> URL? {
        
        // Build base URL
        var components = URLComponents()
        components.scheme = Constants.FlickrURLParams.APIScheme
        components.host = Constants.FlickrURLParams.APIHost
        components.path = Constants.FlickrURLParams.APIPath
        
        // Build query string
        components.queryItems = [URLQueryItem]()
        
        // Query components
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.APIKey, value: Constants.FlickrAPIValues.APIKey));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.SearchMethod, value: Constants.FlickrAPIValues.SearchMethod));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.ResponseFormat, value: Constants.FlickrAPIValues.ResponseFormat));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.Extras, value: Constants.FlickrAPIValues.MediumURL));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.SafeSearch, value: Constants.FlickrAPIValues.SafeSearch));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.DisableJSONCallback, value: Constants.FlickrAPIValues.DisableJSONCallback));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.Per_Page, value: Constants.FlickrAPIValues.Per_Page));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.Page, value: "\(intPage)"));
        components.queryItems?.append(URLQueryItem(name: Constants.FlickrAPIKeys.Text, value: searchString));
        
        return components.url
    }
    
    static func getListingfor(_ strKey: String, intPage: Int = 1, _ complection: @escaping((Result<FlickrModel>)->Void)) {
        
        guard let url = Constants.flickrURLFromParameters(searchString: strKey, intPage: intPage) else { return }
        debugPrint("Request URL:- ",url)
        URLSession.shared.dataTask(with: url) { (data, _, Err) in
            guard let data = data else {
                let strErr = Err?.localizedDescription ?? "Data is nil"
                DispatchQueue.main.async {
                    complection(.error(strErr))
                }
                return
            }
            
            do {
                let arrData = try JSONDecoder().decode(FlickrModel.self, from: data)
                DispatchQueue.main.async {
                    complection(.success(arrData))
                }
            } catch let err {
                DispatchQueue.main.async {
                    complection(.error(err.localizedDescription))
                }
            }
        }.resume()
        
    }
    
} //struct
