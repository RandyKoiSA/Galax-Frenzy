//
//  GameOverScene.swift
//  Galax Frenzy
//
//  Created by Randy Le on 3/12/19.
//  Copyright © 2019 Project Koisa. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics

class GameOverScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    var highScoreLabel: SKLabelNode!
    var currentScoreLabel : SKLabelNode!
    var playButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: size.width / 2,
                                      y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        highScoreLabel = SKLabelNode(text: "High Score: \(Information.highScore)")
        highScoreLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) + 200)
        highScoreLabel.fontSize = 68
        highScoreLabel.fontName = "Helvetica"
        addChild(highScoreLabel)
        
        currentScoreLabel = SKLabelNode(text: "Current Score: \(Information.currentScore)")
        currentScoreLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) + 50)
        currentScoreLabel.fontSize = 60
        currentScoreLabel.fontName = "Helvetica"
        addChild(currentScoreLabel)
        
        playButton = SKSpriteNode(imageNamed: "startButton")
        playButton.position = CGPoint(x: size.width / 2, y: (size.height / 2) - 150)
        playButton.scale(to: CGSize(width: 400, height: 200))

        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // play button check is clicked
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton{
                super.view?.presentScene(GameScene(size: self.size), transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
    
    
}
