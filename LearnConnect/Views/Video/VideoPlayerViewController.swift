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
    var course: Course?
    private var player: AVPlayer?
    private var timeObserver: Any?
    private let viewModel = VideoPlayerViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupVideoPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View will disappear. Saving progress...")
        saveCurrentVideoProgress()
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
        guard let course = course, let user = Session.user else {
            return
        }
        seekToSavedProgress(for: course, user: user)
        
        player?.play()
    }
    
    private func addVideoProgressObserver() {
        guard let player = player else { return }
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self, let duration = player.currentItem?.duration.seconds, duration > 0 else {
                return 
            }
            let progress = time.seconds / duration
            self.saveCurrentVideoProgress()
            print("Current Video Progress: \(progress * 100)%")
        }
    }
    
    private func removeVideoProgressObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func seekToSavedProgress(for course: Course, user: User) {
        let progress = viewModel.getVideoProgress(for: user, in: course)
        print("Fetched progress: \(progress * 100)%")
        
        guard let player = player, let playerItem = player.currentItem else {
            print("Player or PlayerItem is not initialized.")
            return
        }
        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                guard duration.isNumeric && duration.seconds > 0 else {
                    print("Invalid or zero duration.")
                    return
                }
                let targetTime = CMTime(seconds: duration.seconds * Double(progress), preferredTimescale: 600)
                print("Seeking to: \(targetTime.seconds) seconds")
                player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
                    if finished {
                        print("Seek operation completed successfully.")
                    } else {
                        print("Seek operation interrupted.")
                    }
                }
            } catch {
                print("Failed to load duration asynchronously: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveCurrentVideoProgress() {
        guard let course = course, let user = Session.user, let player = player else { return }
        if let duration = player.currentItem?.duration.seconds, duration > 0 {
            let progress = Float(player.currentTime().seconds / duration)
            print("Saving progress: \(progress * 100)%") // Debug log
            viewModel.saveVideoProgress(course: course, user: user, progress: progress)
        }
    }
}
