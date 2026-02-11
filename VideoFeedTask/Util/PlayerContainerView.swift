//
//  PlayerContainerView.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import SwiftUI
import AVFoundation

final class PlayerContainerView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

struct PlayerView: UIViewRepresentable {
  let player: AVPlayer?

  func makeUIView(context: Context) -> PlayerContainerView {
    PlayerContainerView()
  }

  func updateUIView(_ uiView: PlayerContainerView, context: Context) {
    uiView.playerLayer.player = player
    uiView.playerLayer.videoGravity = .resizeAspectFill
  }

  static func dismantleUIView(_ uiView: PlayerContainerView, coordinator: ()) {
    uiView.playerLayer.player = nil
  }
}
