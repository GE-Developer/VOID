//
//  SoundManager.swift
//  Void
//
//  Created by GE-Developer
//

import AVFoundation

@MainActor
final class SoundManager {
    
    var isSoundOff: Bool {
        didSet { defaults.set(isSoundOff, forKey: key) }
    }
    
    static let shared = SoundManager()
    
    private let defaults = UserDefaults.standard
    private let key = AppStorageKey.sound.key
    private var player: AVAudioPlayer?
    
    private init() {
        isSoundOff = defaults.bool(forKey: key)
        configureAudioSession()
    }
    
    func playSound() {
        guard !isSoundOff else { return }
        
        guard let url = Bundle.main.url(forResource: "tapSound", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session: \(error.localizedDescription)")
        }
    }
}
