//
//  ViewController.swift
//  EggTimer
//
//  Created by Mücahit Eren Özkur on 14/03/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //test timer code
    let eggTime : [String : Int] = ["Soft": 3,
                                    "Medium" : 5,
                                    "Hard" : 7]
//Production timer code
//    let eggTime : [String : Int] = ["Soft": 300,
//                                      "Medium" : 420,
//                                      "Hard" : 720]
    
    var timer = Timer() //create a variable for the timer instance so we can invalidate it later to stop multiple instances starting each time you press the button.
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer! //AUDIO PLAYER
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var timeLeft: UILabel!
    
    @IBOutlet weak var stopTimerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set button2 hidden at start
        timeLeft.isHidden = true
        progressBar.setProgress(0, animated: false) //set progress back to zero
        titleLabel.font = .boldSystemFont(ofSize: 30)
        stopTimerButton.isHidden = true
        stopTimerButton.layer.cornerRadius = 15
        timeLeft.font = .boldSystemFont(ofSize: 40)

        
        //rounded edges on progress bar
        progressBar.layer.cornerRadius = 11
        progressBar.clipsToBounds = true
        //progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2.5) //innc. progress height // this works but causes weird rounded edges so we have to apply a height constrint to the progres bar in the storyboard instead.
    
    }//CLOSE SUPER VIEW
    
    @IBAction func stopTimer(_ sender: Any) {
        
            stopSound() //kills sounds
            stopTimerButton.isHidden = true
    
            progressBar.setProgress(0, animated: true) //set progress back to zero
            secondsPassed = 0
            titleLabel.text = "How do you like your eggs?"
            timeLeft.isHidden = true
            titleLabel.alpha = 1
        
    }
    
    @IBAction func hardnessAction(_ sender: UIButton ) {
   
        if progressBar.progress == 0{
            timer.invalidate() //invalidate timer before it starts a new one on pressing button
            titleLabel.font = .boldSystemFont(ofSize: 50)
            let hardness = sender.currentTitle! //soft, medium., hard
            totalTime  = eggTime[hardness]! //force unwrap as we're confident of the spelling set total time to egg

            progressBar.setProgress(0, animated: true) //set progress back to zero
            secondsPassed = 0
            titleLabel.font = .boldSystemFont(ofSize: 30)
            titleLabel.text = "\(hardness) eggs coming up!" //set hardness to egg

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        } else {
            print("Player is playing")
        }
    }

    @objc func updateCounter() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressBar.setProgress(Float(secondsPassed) / Float(totalTime), animated: true)
            print(Float(secondsPassed) / Float(totalTime))
            timeLeft.isHidden = false

            let i = ((totalTime) - (secondsPassed))
            timeLeft.text = String(timeString(time: TimeInterval(i)))
            } else {
                timer.invalidate()
                titleLabel.font = .boldSystemFont(ofSize: 30)
                titleLabel.text = String("Egg's are Ready!!!")
                playSound(soundName: "alarm_sound")
                stopTimerButton.isHidden = false
                timeLeft.text = ""
                timeLeft.font = .boldSystemFont(ofSize: 40)

                UIView.animate(withDuration: 0.5, delay: 0.25, options: [.repeat, .autoreverse], animations: {
                    self.titleLabel.alpha = 0
                }, completion: nil)
            }
        }

        func playSound(soundName: String) {
            let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
            self.player = try! AVAudioPlayer(contentsOf: url!)
            self.player.play()
            self.player.numberOfLoops = -1
        }

        func stopSound() {
                player.stop()
        }

        func timeString(time: TimeInterval) -> String {
            let minute = Int(time) / 60 % 60
            let second = Int(time) % 60

            return String(format: "%02i:%02i", minute, second)
        }
    }
