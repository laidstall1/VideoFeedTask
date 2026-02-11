//
//  AppRouter.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import SwiftUI

@Observable
final class AppRouter {
    var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
