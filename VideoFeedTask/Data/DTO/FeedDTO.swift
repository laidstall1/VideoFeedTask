//
//  FeedResponse.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import Foundation

struct FeedResponseDTO: Decodable, Sendable {
    let page, per_page: Int
    let videos: [PostDTO]
    let total_results: Int
    let next_page, url: String
}

extension FeedResponseDTO: Mappable {
    func map() -> FeedPage {
        .init(
            page: page,
            pageSize: per_page,
            totalResults: total_results,
            posts: videos.map { $0.map() }
        )
    }
}

// MARK: - Video
struct PostDTO: Decodable, Sendable {
    var id, width, height, duration: Int?
    var full_res: String?
    var tags: [String]?
    var url: String?
    var image: String?
    var avg_color: String?
    var user: UserDTO?
    var video_files: [VideoFileDTO]?
    var video_pictures: [VideoPictureDTO]?
}

extension PostDTO: Mappable {
    func map() -> Post {
        .init(
            id: id ?? 0,
            size: VideoSize(
                width: width ?? 0,
                height: height ?? 0
            ),
            duration: duration ?? 0,
            fullResolutionURL: full_res,
            tags: tags ?? [],
            thumbnailURL: image,
            averageColorHex: avg_color,
            user: user?.map(),
            videoFiles: video_files?.compactMap { $0.map() } ?? [],
            previewImages: video_pictures?.compactMap { $0.map() } ?? []
        )
    }
}

// MARK: - User
struct UserDTO: Codable, Sendable {
    var id: Int?
    var name: String?
    var url: String?
}

extension UserDTO: Mappable {
    func map() -> User {
        .init(
            id: id ?? 0,
            name: name ?? "Unknown",
            profileURL: url
        )
    }
}

// MARK: - VideoFile
struct VideoFileDTO: Codable, Sendable {
    var id: Int?
    var quality: QualityDTO?
    var file_type: FileTypeDTO?
    var width, height: Int?
    var fps: Double?
    var link: String?
    var size: Int?
}

extension VideoFileDTO: Mappable {
    func map() -> VideoFile? {
        guard let link = link else {
            return nil
        }
        
        return VideoFile(
            id: id ?? 0,
            quality: quality?.domain,
            fileType: file_type?.domain,
            size: (width != nil || height != nil)
            ? VideoSize(width: width ?? 0, height: height ?? 0)
            : nil,
            fps: fps,
            url: link,
            fileSize: size
        )
    }
}

enum FileTypeDTO: String, Codable, Sendable, DomainConvertible {
    case video_mp4 = "video/mp4"
    
    var domain: VideoFileType? {
        VideoFileType(rawValue: self.rawValue)
    }
}

enum QualityDTO: String, Codable, Sendable, DomainConvertible {
    case hd = "hd"
    case sd = "sd"
    case uhd = "uhd"
    
    var domain: VideoQuality? {
        VideoQuality(rawValue: self.rawValue)
    }
}

// MARK: - VideoPicture
struct VideoPictureDTO: Codable, Sendable {
    var id, nr: Int?
    var picture: String?
}

extension VideoPictureDTO: Mappable {
    func map() -> VideoPreview? {
        guard let id = id,
              let nr = nr,
              let picture = picture else {
            return nil
        }
        
        return VideoPreview(
            id: id,
            index: nr,
            imageURL: picture
        )
    }
}
