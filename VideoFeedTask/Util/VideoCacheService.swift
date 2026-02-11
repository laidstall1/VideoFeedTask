//
//  VideoManager.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//


import AVFoundation
import AVKit

protocol VideoCacheService {
    func localFileURL(for remoteURL: URL) -> URL?
    func downloadIfNeeded(_ url: URL) async throws -> URL
    func preload(_ url: URL)
}

final class VideoCacheServiceImpl: NSObject, VideoCacheService {
    private let fileManager = FileManager.default
    private let cacheDir: URL
    
    override init() {
        self.cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    func localFileURL(for remoteURL: URL) -> URL? {
        let file = cacheDir.appending(component: remoteURL.lastPathComponent)
        return fileManager.fileExists(atPath: file.path()) ? file : nil
    }
    
    func downloadIfNeeded(_ url: URL) async throws -> URL {
        if let local = localFileURL(for: url) { return local }
        let (tempURL, _) = try await URLSession.shared.download(from: url)
        let destination = cacheDir.appending(path: url.lastPathComponent)
        try? fileManager.removeItem(at: destination)
        try? fileManager.moveItem(at: tempURL, to: destination)
        return destination
    }
    
    func preload(_ url: URL) {
        Task.detached {
            _ = try? await self.downloadIfNeeded(url)
        }
    }
}

private extension URL {
  func lastPathComponentWithMP4() -> String {
    var name = lastPathComponent
    if pathExtension.isEmpty {
      name += ".mp4"
    }
    return name
  }
}
