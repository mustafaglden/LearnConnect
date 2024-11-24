//
//  VideoPlayerViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 23.11.2024.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {
    
    // MARK: - Properties
    var videoURL: URL?
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupVideoPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeVideoProgressObserver()
    }
    
    // MARK: - Setup Methods
    private func setupVideoPlayer() {
        guard let videoURL = videoURL else {
            print("Invalid video URL.")
            return
        }

        player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
    
        addChild(playerController)
        view.addSubview(playerController.view)
        playerController.view.frame = view.bounds
        playerController.didMove(toParent: self)

        addVideoProgressObserver()
        player?.play()
    }
    
    private func addVideoProgressObserver() {
        guard let player = player else { return }
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            if let duration = player.currentItem?.duration.seconds, duration > 0 {
                let progress = time.seconds / duration
                print("Current Video Progress: \(progress * 100)%")
            }
        }
    }
    
    private func removeVideoProgressObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}
