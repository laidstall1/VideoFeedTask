//
//  PlaybackState+Util.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 11/02/2026.
//


extension PlaybackState: DomainConvertible {
    var domain: PlaybackUIState {
        switch self {
        case .idle:
            return .idle
        case .loading:
            return .loading
        case .ready:
            return .ready
        case .failed(_):
            return .failed
        }
    }
}
