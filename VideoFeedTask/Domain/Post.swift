//
//  FeedResponse.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 08/02/2026.
//

protocol DomainConvertible {
    associatedtype DomainType
    var domain: DomainType { get }
}

struct FeedPage {
    let page: Int
    let pageSize: Int
    let totalResults: Int
    let posts: [Post]
    
    var hasMore: Bool {
        page < pageSize
    }
}

struct Post: Identifiable {
    let id: Int
    let size: VideoSize
    let duration: Int?
    let fullResolutionURL: String?
    let tags: [String]
    let thumbnailURL: String?
    let averageColorHex: String?
    let user: User?
    let videoFiles: [VideoFile]
    let previewImages: [VideoPreview]
}

struct VideoSize {
    let width: Int
    let height: Int
    
    var aspectRatio: Double {
        guard height > 0 else { return 0 }
        return Double(width) / Double(height)
    }
}

struct User {
    let id: Int
    let name: String
    let profileURL: String?
}

struct VideoFile: Identifiable {
    let id: Int
    let quality: VideoQuality?
    let fileType: VideoFileType?
    let size: VideoSize?
    let fps: Double?
    let url: String
    let fileSize: Int?
    
    var displayQuality: String {
        switch quality {
        case .hd: return "HD"
        case .sd: return "SD"
        case .uhd: return "4K"
        case .none: return ""
        }
    }
}

struct VideoPreview {
    let id: Int
    let index: Int
    let imageURL: String
}

enum VideoFileType: String {
    case mp4
}

enum VideoQuality: String {
    case sd
    case hd
    case uhd
}
