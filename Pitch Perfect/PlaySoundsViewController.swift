//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Adam Steff on 15/05/2015.
//  Copyright (c) 2015 Adam Steff. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL:receivedAudio.filePathUrl , error: nil)
        audioPlayer.enableRate = true;
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioSlowly(sender: UIButton) {
        audioPlayer.rate = 0.5
        resetAudioEngine()
        playRecordedAudio()
    }
   
    @IBAction func playAudioFast(sender: UIButton) {
        audioPlayer.rate = 2.0
        resetAudioEngine()
        playRecordedAudio()
    }

    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        resetAudioEngine()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariableEffects(1000,wetDryMix:0, delayTime:0)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariableEffects(-1000,wetDryMix:0,delayTime:0)
    }
    
    
    @IBAction func playWithReverb(sender: UIButton) {
        playAudioWithVariableEffects(1.0,wetDryMix:50,delayTime:0)
       
    }
    
    @IBAction func playWithEcho(sender: UIButton) {
        playAudioWithVariableEffects(1,wetDryMix:0,delayTime: 0.5)
    }
    
    func playAudioWithVariableEffects(pitch: Float, wetDryMix: Float, delayTime: NSTimeInterval){
        resetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //controls the pitch
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //controls the reverb
        let reverb = AVAudioUnitReverb()
        reverb.wetDryMix = wetDryMix
        audioEngine.attachNode(reverb)
        
        //controls the echo
        let delay = AVAudioUnitDelay()
        delay.delayTime = delayTime
        audioEngine.attachNode(delay)
        
        //attach the effects to the Audio Engine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: reverb, format: nil)
        audioEngine.connect(reverb, to: delay, format: nil)
        audioEngine.connect(delay, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playRecordedAudio(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func resetAudioEngine(){
        //reset audio player and audio engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
