//
//  MainScene.swift
//  Galax Frenzy
//
//  Created by Randy Le on 3/11/19.
//  Copyright © 2019 Project Koisa. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics

class MainScene: SKScene {
    var transition = SKTransition.fade(withDuration: 5.0)
    
    let background = SKSpriteNode(imageNamed: "background")
    let title = SKLabelNode(text: "GALAX FRENZY")
    let playButton = SKSpriteNode(imageNamed: "startButton")
    
    override func didMove(to view: SKView) {
        // BACKGROUND SET UP
        background.position = CGPoint(x: size.width / 2,
                                             y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        // TITLE INITIALIZER
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 350)
        title.fontName = "Helvetica"
        title.fontSize = 70
        title.name = "title"
        addChild(title)
        
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        playButton.scale(to: CGSize(width: 400, height: 200))
        playButton.name = "play"
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
