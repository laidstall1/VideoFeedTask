//
//  VideoFeedTaskApp.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 05/02/2026.
//

import SwiftUI

@main
struct VideoFeedTaskApp: App {
    @State private var router = AppRouter()
    let configuration: Configuration
    
    init() {
        let apiClient = APIClientServiceHandler(
            session: SessionHandler.session,
            configuration: .init(
                baseURL: AppConfigKeys.baseURL,
                baseHeaders: ["accept": "application/json"]
            )
        )
        configuration = Configuration(apiClient: apiClient)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MainTabView()
            }
            .environment(router)
            .environment(configuration)
        }
    }
}
