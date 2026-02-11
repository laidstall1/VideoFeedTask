//
//  Endpoints.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 08/02/2026.
//
import Foundation

enum APIEndpoints {
    static func fetchPosts(perPage: String, page: String) -> APIEndpoint {
        .init(
            servicePath: "/videos",
            path: "search",
            httpMethod: .get,
            urlQueries: [
                "query": "people",
                "per_page": perPage,
                "page": page
            ]
        )
    }
}
