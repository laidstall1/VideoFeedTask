//
//  File.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//

import Foundation
import AVFoundation

enum PlaybackState {
    case idle
    case loading
    case ready
    case failed(Error?)
}

@Observable
@MainActor
final class VideoPlaybackService {
    private(set) var player: AVQueuePlayer = AVQueuePlayer()
    private var looper: AVPlayerLooper?
    private var statusObserver: NSKeyValueObservation?
    var state: PlaybackState = .idle
   
    var isPlaying: Bool {
        player.timeControlStatus == .playing
    }
    
    func loadLocalFile(_ localURL: URL, shouldLoop: Bool = true) {
        stop()
        let item = AVPlayerItem(url: localURL)
        player.replaceCurrentItem(with: item)
        if shouldLoop {
            looper = AVPlayerLooper(player: player, templateItem: item)
        }
    }
    
    func loadRemoteStream(_ remoteURL: URL) {
        stop()
        let item = AVPlayerItem(url: remoteURL)
        player.replaceCurrentItem(with: item)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    
    func stop() {
        player.pause()
        player.removeAllItems()
        looper = nil
    }
    
    nonisolated
    func cleanup() {
        Task { @MainActor in
            stop()
        }
    }
    
    deinit {
        //        player.pause()
        //        player.replaceCurrentItem(with: nil)
        //        looper = nil
        cleanup()
    }
    
    func play(url: URL, cache: VideoCacheService) {
        if let local = cache.localFileURL(for: url) {
            loadLocalFile(local)
        } else {
            loadRemoteStream(url)
            cache.preload(url)
        }
        play()
    }
    
    private func observe(_ item: AVPlayerItem) {
        statusObserver?.invalidate()
        statusObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self else { return }
            Task { @MainActor in
                switch item.status {
                case .readyToPlay:
                    self.state = .ready
                case .failed:
                    self.state = .failed(item.error)
                default:
                    break
                }
            }
        }
    }
}

