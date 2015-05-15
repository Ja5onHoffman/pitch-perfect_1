//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jason Hoffman on 5/13/15.
//  Copyright (c) 2015 JHM. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
                
        self.readyToRecord()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        self.recordingInProgress()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder?.delegate = self
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        } else {
            // Code below shows alert controller if recording fails. User starts from beginning
            let alertController = UIAlertController(title: "Hmm...", message: "Your recording didn't work for some reason. Let's try again.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true) { () -> Void in
            self.readyToRecord()
            }
        }
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        
        self.readyToRecord()
        audioRecorder.stop()
    }
    
    // Changing label text instead of hiding two different labels
    // Two functions below combine recording action into one function
    func readyToRecord() {
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true
    }
    
    func recordingInProgress() {
        recordButton.enabled = false
        recordingLabel.text = "recording"
        stopButton.hidden = false
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
        let data = sender as! RecordedAudio
        playSoundsVC.receivedAudio = data
    }
}

