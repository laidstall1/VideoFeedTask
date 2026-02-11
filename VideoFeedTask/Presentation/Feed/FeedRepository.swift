//
//  RequestHandler.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import Foundation

protocol FeedRepository {
    func fetchPosts(perPage: Int, page: Int) async throws(APIError) -> FeedPage
}

struct FeedRepositoryImpl: FeedRepository {
    
    let service: APIClientService
    
    init(service: APIClientService) {
        self.service = service
    }
    
    func fetchPosts(perPage: Int, page: Int) async throws(APIError) -> FeedPage {
        let endP = APIEndpoints.fetchPosts(perPage: "\(perPage)", page: "\(page)")
        let response: FeedResponseDTO = try await service.request(endP, decoder: JSONDecoder())
        return response.map()
    }
}
