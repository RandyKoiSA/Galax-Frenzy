//
//  GameViewController.swift
//  Galax Frenzy
//
//  Created by Randy Le on 3/9/19.
//  Copyright © 2019 Project Koisa. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    var bgMusic = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainScene(size: CGSize(width: 2048,
                                           height: 1536))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        playBGM()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func playBGM(){
        if let path = Bundle.main.path(forResource: "Sci-fi Pulse Loop", ofType: "wav"){
            let url = URL(fileURLWithPath: path)
            print(url)
            
            do{
                bgMusic = try AVAudioPlayer(contentsOf: url)
                bgMusic.prepareToPlay()
                bgMusic.numberOfLoops = -1
                bgMusic.play()
            }
            catch let error{ print(error.localizedDescription) }
            
        }
    }
}
