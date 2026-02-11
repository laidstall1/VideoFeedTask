//
//  PlayerViewModel.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 09/02/2026.
//

import SwiftUI
import AVFoundation

@Observable
@MainActor
final class PlayerViewModel {

    let player = AVPlayer()

    func configure(url: URL) {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func cleanup() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }

    deinit {
        player.pause()
    }
}
