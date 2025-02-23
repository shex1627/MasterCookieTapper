import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var goodCookieSound: AVAudioPlayer?
    private var badCookieSound: AVAudioPlayer?
    
    private init() {
        setupSounds()
    }
    
    private func setupSounds() {
        // Good cookie sound
        if let goodSoundPath = Bundle.main.path(forResource: "click", ofType: "wav") {
            print("Found good sound file at: \(goodSoundPath)")
            do {
                goodCookieSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: goodSoundPath))
                goodCookieSound?.prepareToPlay()
                print("Successfully loaded good sound")
            } catch {
                print("Error loading good sound: \(error)")
            }
        } else {
            print("Could not find click.wav in bundle")
        }
        
        // Bad cookie sound
        if let badSoundPath = Bundle.main.path(forResource: "bad", ofType: "wav") {
            print("Found bad sound file at: \(badSoundPath)")
            do {
                badCookieSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: badSoundPath))
                badCookieSound?.prepareToPlay()
                print("Successfully loaded bad sound")
            } catch {
                print("Error loading bad sound: \(error)")
            }
        } else {
            print("Could not find bad.wav in bundle")
        }
    }
    
    func playGoodCookieSound() {
        if goodCookieSound?.isPlaying == true {
            goodCookieSound?.stop()
            goodCookieSound?.currentTime = 0
        }
        goodCookieSound?.play()
    }
    
    func playBadCookieSound() {
        if badCookieSound?.isPlaying == true {
            badCookieSound?.stop()
            badCookieSound?.currentTime = 0
        }
        badCookieSound?.play()
    }
}