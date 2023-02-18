import Flutter
import UIKit
import AVFoundation

public class AudioLibPlugin: NSObject, FlutterPlugin {

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var channel: FlutterMethodChannel
    private var observers: [Any] = []
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flx.fischer/audio", binaryMessenger: registrar.messenger())
        let instance = AudioLibPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "play":
            guard let arguments = call.arguments as? [String: Any],
                  let urlString = arguments["url"] as? String,
                  let url = URL(string: urlString) else { return result(0) }
            play(url)
        case "pause":
            pause()
        case "resume":
            resume()
        default:
            result(FlutterMethodNotImplemented)
        }
        result(1)
    }
    
    private func play(_ url: URL = URL(string: "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3")!) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            // TODO: error handlig
        }
        
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        observers.removeAll()
        
        playerItem = AVPlayerItem(url: url)
        if player != nil {
            player?.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        let completeObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: nil,
            using: onItemComplete
        )
        
        observers.append(completeObserver)
        
        player?.play()
        channel.invokeMethod("audio.onStart", arguments: nil)
    }
    
    private func resume() {
        player?.play()
        channel.invokeMethod("audio.onResume", arguments: nil)
    }
    
    private func pause() {
        player?.pause()
        channel.invokeMethod("audio.onPause", arguments: nil)
    }
    
    private func onItemComplete(notification _: Notification) {
        player?.pause()
        playerItem = nil
        player = nil
        channel.invokeMethod("audio.onComplete", arguments: nil)
    }
    
    deinit {
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        observers.removeAll()
    }
}
