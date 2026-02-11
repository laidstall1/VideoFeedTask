//
//  MainTabView.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 08/02/2026.
//

import SwiftUI

struct MainTabView: View {
    @Environment(Configuration.self) var configuration
    @Environment(AppRouter.self) var router
    
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                FeedView(viewModel: FeedViewModel(repository: FeedRepositoryImpl(service: configuration.apiClient)))
            }
            .tabItem {
                VStack {
                    Image(systemName: "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    Text("Home")
                }
            }
            .tag(0)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "person")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                    Text("Profile")
                }
            }
            .tag(1)
        }
        .tint(.black)
    }
}

#Preview {
  MainTabView()
}
