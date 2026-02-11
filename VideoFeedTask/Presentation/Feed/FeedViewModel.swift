//
//  FeedViewModel.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import Foundation

enum PlaybackUIState: Equatable {
    case idle
    case loading
    case ready
    case failed
}

@Observable
class FeedViewModel {
    @ObservationIgnored let repository: FeedRepository
    var showError = ""
    var isLoading = false
    var posts: [Post]?
    
    init(repository: FeedRepository) {
        self.repository = repository
    }
    
    var activePostID: Int?
    var currentPlayingID: Int?
    
    @ObservationIgnored
    var playbackState: PlaybackUIState {
        playback.state.domain
    }
    
    var playback = VideoPlaybackService()
    @ObservationIgnored let cache: VideoCacheService = VideoCacheServiceImpl()
    
    func visiblePostChanged(_ id: Int?) {
        guard let id,
              let posts,
              let index = posts.firstIndex(where: { $0.id == id }) else {
            playback.pause()
            currentPlayingID = nil
            return
        }
        guard id != currentPlayingID else { return }
        currentPlayingID = id
        let post = posts[index]
        guard let urlString = post.videoFiles.first?.url,
              let url = URL(string: urlString)
        else { return }
        playback.play(url: url, cache: cache)
        preloadNext(posts, currentIndex: index)
    }
    
    func preloadNext(_ posts: [Post], currentIndex: Int) {
        let nextRange = (currentIndex+1)...min(currentIndex+2, posts.count)
        for index in nextRange {
            if let urlString = posts[index].videoFiles.first?.url,
               let url = URL(string: urlString) {
                cache.preload(url)
            }
        }
    }
    
    func fetchPosts() async {
        showError = ""
        isLoading = true
        do {
            let result = try await repository.fetchPosts(perPage: 80, page: 1)
            posts = result.posts
            isLoading = false
        }
        catch {
            isLoading = false
            showError = error.userMessage ?? ""
        }
    }
    
    func play(url: URL) {
        playback.play(url: url, cache: cache)
    }
}
