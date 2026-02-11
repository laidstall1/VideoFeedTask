//
//  FeedView.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//
import SwiftUI
struct FeedView: View {
    @Bindable var viewModel: FeedViewModel
    @State private var visiblePostID: Int?
    @State var shouldPause = false
    @State var showLoader = false
    @State var showError = false
    
    var body: some View {
        ScrollView(.vertical) {
            if let posts = viewModel.posts {
                LazyVStack(spacing: 0) {
                    ForEach(Array(posts.enumerated()), id: \.1.id) { index, post in
                        PostView(post: post,
                                 player: viewModel.playback.player,
                                 shouldPause: $shouldPause,
                                 showError: $showError,
                                 showLoader: $showLoader) { url in
                            viewModel.play(url: url)
                        }
                        .onChange(of: shouldPause) { _, newValue in
                            newValue ? viewModel.playback.play() : viewModel.playback.pause()
                        }
                        .onChange(of: viewModel.playbackState, { _, newValue in
                            showLoader = newValue == .loading
                            showError = newValue == .failed
                        })
                        .containerRelativeFrame([.horizontal, .vertical])
                        .id(post.id)
                    }
                }
                .scrollTargetLayout()
                .onAppear {
                    viewModel.visiblePostChanged(posts.first?.id)
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $visiblePostID)
        .onChange(of: visiblePostID, { _, newValue in
            viewModel.visiblePostChanged(newValue)
        })
        .ignoresSafeArea()
        .task {
            debugPrint("Network Request")
            await viewModel.fetchPosts()
        }
    }
}
