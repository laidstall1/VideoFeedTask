//
//  AppConfig.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 10/02/2026.
//
import Foundation

@Observable
class Configuration {
    let apiClient: APIClientService
    
    init(apiClient: APIClientService) {
        self.apiClient = apiClient
    }
}
