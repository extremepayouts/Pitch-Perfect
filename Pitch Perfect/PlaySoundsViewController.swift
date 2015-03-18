//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Joe White on 3/11/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
 
        // Needed to tell phone to play thru speakers and not ear speaker
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play();
    }
    
    @IBAction func playAudio(sender: UIButton) {
        audioPlayer.stop() 
        audioEngine.stop()
        audioEngine.reset()
        
        // If the slow button is pressed slow the rate and if fast button increase the rate
        switch sender.tag
        {
            case 1:
                audioPlayer.rate = 0.5
            case 2:
                audioPlayer.rate = 2.5
            default:
                audioPlayer.rate = 0.5
        }
        
        audioPlayer.play()
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        audioPlayer.stop()
    }

}
