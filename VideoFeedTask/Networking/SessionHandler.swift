//
//  CwSessionHandler.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 10/02/2026.
//
import Alamofire
import Foundation

struct SessionHandler {
    private init() {}
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        return Session(
            configuration: configuration,
            interceptor: nil,
            eventMonitors: [NetworkLogger()])
    }()
}
