//
//  ViewController.swift
//  ARRace
//
//  Created by Răzvan-Gabriel Geangu on 25/11/2017.
//  Copyright © 2017 Răzvan-Gabriel Geangu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // Score logic
    var scoreLabel: UILabel!
    private var userScore: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.scoreLabel.text = "Score: \(String(self.userScore))"
            }
        }
    }
    
    // Timer logic
    var timerLabel: UILabel!
    private var timerValue: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.timerLabel.text = String(self.timerValue)
            }
        }
    }
    var timer = Timer()
    
    // Feedback logic
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var endGameView: UIView!
    var didStart = false
    var timerIsRunning = false
    
    // AR Ring
    var ringNode: ARRing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.isUserInteractionEnabled = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        // let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        initUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    fileprivate func initUIElements() {
        // Set the initial score to 0
        self.userScore = 0
        
        // Create the label for the score on the top of the screen
        self.scoreLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 50, width: 200, height: 50))
        self.scoreLabel.textColor = .white
        self.scoreLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 36)
        self.scoreLabel.textAlignment = .center
        
        // Add score label to the view
        self.sceneView.addSubview(self.scoreLabel)
        
        // Set the initial value of the timer
        self.timerValue = 15
        
        // Create the label for the timer on the bottom of the screen
        self.timerLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height - 100, width: 200, height: 50))
        self.timerLabel.textColor = .white
        self.timerLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 36)
        self.timerLabel.textAlignment = .center
        
        // Add timer label to the view
        self.sceneView.addSubview(self.timerLabel)
        
        endGameView = UIView(frame: self.view.frame)
        endGameView.backgroundColor = .white
    }
    
    fileprivate func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateTimer() {
        if timerValue == 0 {
            timer.invalidate()
            timerIsRunning = false
            
            scoreLabel.textColor = .black
            endGameView.addSubview(scoreLabel)
            
            let restartButton = UIButton(frame: CGRect(x: endGameView.frame.width / 2 - 50, y: endGameView.frame.height / 2 - 50, width: 100, height: 100))
            restartButton.backgroundColor = .black
            restartButton.layer.cornerRadius = 0.5 * restartButton.bounds.size.width
            restartButton.clipsToBounds = true
            restartButton.setTitleColor(.white, for: .normal)
            restartButton.setTitle("Restart", for: .normal)
            restartButton.addTarget(self, action: #selector(ViewController.restartTapped), for: .touchUpInside)
            endGameView.addSubview(restartButton)
            
            self.sceneView.addSubview(endGameView)
        } else {
            timerValue -= 1
            timerLabel.text = "\(timerValue)"
        }
    }
    
    @objc fileprivate func restartTapped() {
        endGameView.removeFromSuperview()
        timerValue = 10
        scoreLabel.textColor = .white
        userScore = 0
        
        self.sceneView.addSubview(scoreLabel)
    }
}
