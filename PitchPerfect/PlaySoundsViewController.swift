//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Jason Hoffman on 5/13/15.
//  Copyright (c) 2015 JHM. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: &error)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Rate buttons combined.
    // Maybe ternary operator not appropriate here since only using one tag?
    @IBAction func rateButtonPressed(sender: UIButton) {
        self.stopAll()
        sender.tag == 200 ? audioPlayerSetAndPlay(atRate: 0.5, andTime: 0.0) : audioPlayerSetAndPlay(atRate: 2.0, andTime: 0.0)
    }
    
    // Function for use with either rate button
    func audioPlayerSetAndPlay(atRate rate: Float, andTime time: NSTimeInterval) {
        audioPlayer.rate = rate
        audioPlayer.currentTime = time
        audioPlayer.play()
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        self.stopAll()
    }
    
    // Combines buttons  to one action.
    @IBAction func pitchButtonPressed(sender: UIButton) {
        sender.tag == 200 ? playAudioWithVariablePitch(1000) : playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        self.stopAll()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    // Stops all audio regardless of type
    func stopAll() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
