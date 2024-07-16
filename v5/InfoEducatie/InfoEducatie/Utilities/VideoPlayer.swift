//
//  VideoPlayer.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 06.07.2024.
//

import Combine
import AVKit
import SwiftUI

class VideoHostingController: AVPlayerViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    var videoName: String
    var videoType: String

    func makeUIViewController(context: Context) -> VideoHostingController {
        let controller = VideoHostingController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill

        if let path = Bundle.main.path(forResource: videoName, ofType: videoType) {
            let player = AVQueuePlayer(url: URL(fileURLWithPath: path))
            let item = AVPlayerItem(url: URL(fileURLWithPath: path))
            let playerLooper = AVPlayerLooper(player: player, templateItem: item)
            
            player.isMuted = true
            player.play()
            
            context.coordinator.player = player
            context.coordinator.playerLooper = playerLooper
            controller.player = player
        }
        
        return controller
    }

    func updateUIViewController(_ uiViewController: VideoHostingController, context: Context) {
        uiViewController.player?.play()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var player: AVQueuePlayer?
        var playerLooper: AVPlayerLooper?
        var cancellables: Set<AnyCancellable> = []

        init() {
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
                .sink { [weak self] _ in
                    self?.play()
                }
                .store(in: &cancellables)

            NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
                .sink { [weak self] _ in
                    self?.pause()
                }
                .store(in: &cancellables)
        }

        func play() {
            player?.play()
        }

        func pause() {
            player?.pause()
        }
    }
}

struct VideoBackgroundView<Content: View>: View {
    var videoName: String
    var videoType: String
    var saturation: Double = 1
    @Binding var showVideo: Bool?

    var content: () -> Content

    var body: some View {
        ZStack {
            if showVideo ?? true {
                VideoPlayerView(videoName: videoName, videoType: videoType)
                    .saturation(saturation)
                    .edgesIgnoringSafeArea(.all)
                    .animation(.none)
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                            NotificationCenter.default.post(name: Notification.Name("PlayVideo"), object: nil)
                        }
                    }
                    .onDisappear {
                        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
                    }
            }
            content()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            NotificationCenter.default.post(name: Notification.Name("PlayVideo"), object: nil)
        }
    }
}
