//
//  HTTPHeaderField.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//

import Foundation

enum HTTPHeaderField: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
   case jsonEncoding = "application/json"
   case urlEncoding = "application/x-www-form-urlencoded"
   case formData = "multipart/form-data"
}

struct AppConfigKeys {
    static var baseURL: URL? {
        if let urlString = Bundle.main.infoDictionary?["BaseURL"] as? String {
            return URL(string: urlString)
        }
        return nil
    }
}
