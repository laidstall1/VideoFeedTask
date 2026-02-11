//
//  EndpointType.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum BodyParameter {
    case data(Data)
    case dictionary([String: Any], options: JSONSerialization.WritingOptions = [])
    case encodable(Encodable, encoder: JSONEncoder = .init())
}

protocol EndPointType: Sendable {
    var baseURL: URL? { get }
    
    var servicePath: String { get }

    var path: String { get }

    var httpMethod: HTTPMethod { get }

    var urlQueries: [String: String]? { get }

    var headers: [String: String]? { get }

    var bodyParameter: BodyParameter? { get }
  
    var requiresAuthorization: Bool { get }
}

struct APIEndpoint: EndPointType {
    let baseURL: URL?
    let servicePath: String
    let path: String
    let httpMethod: HTTPMethod
    let urlQueries: [String: String]?
    let headers: [String: String]?
    let bodyParameter: BodyParameter?
    var requiresAuthorization: Bool
  

    init(
        baseURL: URL? = nil,
        servicePath: String,
        path: String,
        httpMethod: HTTPMethod,
        urlQueries: [String: String]? = nil,
        headers: [String: String]? = nil,
        bodyParameter: BodyParameter? = nil,
        requiresAuthorization: Bool = false
    ) {
        self.baseURL = baseURL
        self.servicePath = servicePath
        self.path = path
        self.httpMethod = httpMethod
        self.urlQueries = urlQueries
        self.headers = headers
        self.bodyParameter = bodyParameter
        self.requiresAuthorization = requiresAuthorization
    }
}
