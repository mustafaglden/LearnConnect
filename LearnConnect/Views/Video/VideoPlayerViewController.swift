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
    var speedButtons: [UIButton] = []
    private var timeObserver: Any?
    private let viewModel = VideoPlayerViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupVideoPlayer()
        setupSpeedControlButtons()
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
    
    func setupSpeedControlButtons() {
        let speeds: [Float] = [0.5, 1.0, 1.5, 2.0]
        let buttonTitles = speeds.map { "\($0)x" }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(speedButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            speedButtons.append(button)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setDefaultSpeed() {
        let defaultSpeed: Float = 1.0
        player?.rate = defaultSpeed

        // Highlight the default button (1.0x)
        for button in speedButtons {
            if button.titleLabel?.text == "\(defaultSpeed)x" {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }

    @objc func speedButtonTapped(_ sender: UIButton) {
        let speeds: [Float] = [0.5, 1.0, 1.5, 2.0]
        let selectedSpeed = speeds[sender.tag]
        player?.rate = selectedSpeed
        // Update button appearance to highlight the active speed
        for button in speedButtons {
            if button == sender {
            button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }

        print("Playback speed set to: \(selectedSpeed)x")
    }
}
