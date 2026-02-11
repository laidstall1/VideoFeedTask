//
//  PostView.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 08/02/2026.
//

import SwiftUI
import AVFoundation

struct PostView: View {
    let post: Post
    let player: AVPlayer
    @State var currentIndex = 0
    @Binding var shouldPause: Bool
    @Binding var showError: Bool
    @Binding var showLoader: Bool
    let onVideoChange: (URL) -> Void

    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                      ForEach(Array(post.videoFiles.enumerated()), id: \.1.id) { index, file in
                          PlayerView(player: player)
                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                              .tag(index)
                              .clipped()
                              .onTapGesture {
                                  shouldPause.toggle()
                              }
                      }
                  }
             .tabViewStyle(.page(indexDisplayMode: .never))
                  .onChange(of: currentIndex) { _, newIndex in
                      changeVideo(at: newIndex)
                  }
            
            HStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(post.user?.name ?? "")
                            .fontWeight(.semibold)
                        
                        Text("Rocket ship prepare for takeoff!!!")
                    }
                    .foregroundStyle(.white)
                    .font(.subheadline)
                }
                
                Spacer()
                
                VStack(spacing: 28) {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(.gray)
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.white)
                            
                            Text("27")
                                .font(.caption)
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "ellipsis.bubble.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.white)
                            
                            Text("27")
                                .font(.caption)
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "bookmark.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.white)
                            
                            Text("27")
                                .font(.caption)
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .resizable()
                            .frame(width: 22, height: 28)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.bottom, 80)
            .padding()
            
            if showError {
                Text("Unable to play video, something went wrong.")
                
            } else if showLoader {
                ProgressView()
            }
        }
    }
    
    private func changeVideo(at index: Int) {
        guard post.videoFiles.indices.contains(index) else { return }
              let urlString = post.videoFiles[index].url
        if let url = URL(string: urlString) {
            onVideoChange(url)
        }
    }
}
