//
//  NetworkService.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import Alamofire
import Foundation

typealias APIResponse = (data: Data, statusCode: Int)

protocol APIClientService: Sendable {
    func request(_ endpoint: any EndPointType) async throws (APIError) -> APIResponse
    func request<T>(_ endpoint: any EndPointType, decoder: JSONDecoder) async throws (APIError) -> T where T: Decodable
}

class APIClientServiceHandler: APIClientService {
    private let logger: LoggerManager
    private let configuration: Configuration
    private let session: Session
    
    init(session: Session, logger: LoggerManager = LoggerManager.shared,
         configuration: Configuration) {
        self.configuration = configuration
        self.session = session
        self.logger = logger
    }
    
    func request(_ endpoint: any EndPointType) async throws (APIError) -> APIResponse {
        guard let request = buildURLRequest(from: endpoint) else {
            throw .invalidEndpoint
        }
        
        let response = await session.request(request)
            .serializingData()
            .response
        
        let statusCode = response.response?.statusCode ?? 0
        
        switch response.result {
        case .success(let data):
            switch statusCode {
            case 200..<300:
                return (data, statusCode)
                
            case 400..<500:
                let message = parseErrorMessage(from: data) ?? "Client error"
                throw .clientError(message: message)
                
            case 500..<600:
                let message = parseErrorMessage(from: data) ?? "Server error"
                throw .serverError(message: message)
                
            default:
                throw .unexpectedResponse
            }
            
        case .failure(let error):
            throw .networkError(error: error)
        }
    }
    
    func request<T>(_ endpoint: any EndPointType, decoder: JSONDecoder) async throws (APIError) -> T where T: Decodable {
        do {
            let result = try await request(endpoint)
            return try decoder.decode(T.self, from: result.data)
        }
        catch {
            if let error = error as? APIError {
                throw error
            }
            throw .unexpectedResponse
        }
    }
    
    struct Configuration: Sendable {
        let baseURL: URL?
        let baseHeaders: [String: String]
        var bearerProvider: (@Sendable () -> String?)?
        
        public init(baseURL: URL?, baseHeaders: [String: String],  bearerProvider: (@Sendable () -> String?)? = nil) {
            self.baseURL = baseURL
            self.baseHeaders = baseHeaders
            self.bearerProvider = bearerProvider
        }
        
        public static let `default` = Configuration(baseURL: nil, baseHeaders: [:])
    }
    
    private func buildURLRequest(from endpoint: EndPointType) -> URLRequest? {
        let host = endpoint.baseURL?.host ?? configuration.baseURL?.host
        guard let host = host else { return nil }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = endpoint.servicePath + (endpoint.path.hasPrefix("/") ? endpoint.path : "/" + endpoint.path)
        
        if let urlQueries = endpoint.urlQueries {
            var queryItems: [URLQueryItem] = []
            for item in urlQueries {
                queryItems.append(URLQueryItem(name: item.key, value: item.value))
            }
            components.queryItems = queryItems
        }
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        var endpointHeaders = endpoint.headers ?? [:]
        if endpoint.requiresAuthorization, let token = configuration.bearerProvider?() {
            endpointHeaders[HTTPHeaderField.authorization.rawValue] = "Bearer \(token)"
        }
        if endpoint.httpMethod == .post {
            endpointHeaders[HTTPHeaderField.contentType.rawValue] = ContentType.jsonEncoding.rawValue
        } else if endpoint.httpMethod == .get {
            if let queryParams = endpoint.urlQueries, !queryParams.isEmpty {
                endpointHeaders[HTTPHeaderField.contentType.rawValue] = ContentType.urlEncoding.rawValue
            }
        }
        let mergedHeaders = configuration.baseHeaders.merging(endpointHeaders) { (_, new) in new }
        request.allHTTPHeaderFields = mergedHeaders
        
        switch endpoint.bodyParameter {
        case let .data(data):
            request.httpBody = data
        case let .dictionary(dict, options):
            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: options)
            request.httpBody = jsonData
        case let .encodable(object, encoder):
            let data = try? encoder.encode(object)
            request.httpBody = data
        default:
            break
        }
        return request
    }
    
    private func parseErrorMessage(from data: Data) -> String? {
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return json?["message"] as? String ?? json?["error"] as? String
    }
}

