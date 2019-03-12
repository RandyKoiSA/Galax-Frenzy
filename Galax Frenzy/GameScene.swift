//
//  GameScene.swift
//  Galax Frenzy
//
//  Created by Randy Le on 3/9/19.
//  Copyright © 2019 Project Koisa. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "background")
    let title = SKLabelNode(text: "GALAX FRENZY")
    var playableRect : CGRect
    var scoreLabel : SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
            
            if score > highScore {
                highScore = score
            }
        }
    }
    var highScore = 0 {
        didSet{
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
    var isGameOver: Bool = true
    var playButton = SKSpriteNode(imageNamed: "startButton")
    var highScoreLabel: SKLabelNode!
    
    // texture
    var enemyTexture = SKTexture(imageNamed: "enemy_spaceship")
    
    // player properties
    var player = SKSpriteNode(imageNamed: "player_spaceship")
    var playerMovePerSec : CGFloat = 600.0
    var velocity = CGPoint.zero
    var isPlayerDead: Bool = true
    
    // delta time properties
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    // touch properties
    var lastTouchLocation: CGPoint?
    
    // MARK: Override Functions
    override func didMove(to view: SKView) {
        // BACKGROUND SET UP
        background.position = CGPoint(x: size.width / 2,
                                      y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        // SCORE SET UP
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 5)
        scoreLabel.fontSize = 40
        scoreLabel.fontName = "Helvetica"
        scoreLabel.zPosition = 0
        
        // MENU SET UP
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 350)
        title.fontName = "Helvetica"
        title.fontSize = 70
        title.name = "title"
        addChild(title)
        
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        playButton.scale(to: CGSize(width: 300, height: 200))
        playButton.name = "play"
        addChild(playButton)
        
        highScoreLabel = SKLabelNode(text: "High Score: 0")
        highScoreLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) + 200)
        highScoreLabel.fontSize = 68
        highScoreLabel.fontName = "Helvetica"
        highScoreLabel.name = "highScore"
        addChild(highScoreLabel)
        
        // PLAYER SET UP
        player.position = CGPoint(x: size.width / 2, y: 400)
        player.zPosition = 1
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        player.physicsBody?.isDynamic = false
        player.name = "player"

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // run and changes player movement
        if(!isGameOver){
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                lastTouchLocation = touchLocation
                movePlayer(location: touchLocation)
            }
        }
        // play button check is clicked
        else {
            if let touch = touches.first{
                let pos = touch.location(in: self)
                let node = self.atPoint(pos)
                
                if node == playButton{
                    startGame()
                }
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        movePlayer(location: touchLocation)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Update and get delta time
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
     
        if let lastTouchLocation = lastTouchLocation {
            let diff = lastTouchLocation - player.position
            if (diff.length() <= playerMovePerSec * CGFloat(dt)){
                player.position = lastTouchLocation
                velocity = CGPoint(x: 0, y: 0)
            } else {
                moveSprite(sprite: player, velocity: velocity)
            }
        }
        boundsCheckPlayer()
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableRect = CGRect(x: 0,
                              y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    func movePlayer(location: CGPoint){
        let offset = CGPoint(x: location.x - player.position.x,
                             y: location.y - player.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * playerMovePerSec,
                           y: direction.y * playerMovePerSec)
        
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint){
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
                                  y: sprite.position.y + amountToMove.y)
    }
    
    func boundsCheckPlayer(){
        let bottomLeft = CGPoint(x: 0,
                                 y: playableRect.minY)
        let topRight = CGPoint(x: size.width,
                               y: playableRect.maxY)
        
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if player.position.x >= topRight.x {
            player.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if player.position.y <= bottomLeft.y{
            player.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if player.position.y >= topRight.y{
            player.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func spawnEndlessEnemy(){
        // ACTION SET UP
        run(SKAction.repeatForever(
            SKAction.sequence(
                [SKAction.run {
                    let random = Int.random(in: 2...10)
                    for _ in 1...random{
                        self.spawnEnemy()
                    }
                    }
                    , SKAction.wait(forDuration: 1.5)])), withKey: "spawnEnemy")
    }
    
    func spawnEnemy(){
        if(!isGameOver){
            let enemy = SKSpriteNode(imageNamed: "enemy_spaceship")
            enemy.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                     y: size.height)
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: 35)
            enemy.physicsBody?.isDynamic = false
            enemy.zPosition = 0
            enemy.name = "enemy"
            addChild(enemy)
            
            let actionMove = SKAction.moveTo(y: 0, duration: TimeInterval.random(in: 2...5))
            let actionRemove = SKAction.removeFromParent()
            let actionAddScore = SKAction.run {
                if (!self.isGameOver){
                    self.score += 1
                }
            }
            
            enemy.run(SKAction.sequence([actionMove, actionRemove, actionAddScore]))
        }
    }
    
    func checkCollisions(){
        if (!isPlayerDead){
            enumerateChildNodes(withName: "enemy") {
                (node, stop) in
                let enemy = node as! SKSpriteNode
                if enemy.intersects(self.player){
                    self.playerDies()
                    self.isPlayerDead = true
                }
            }
        }
    }
    
    func playerDies(){
        self.player.removeFromParent()
        self.scoreLabel.removeFromParent()
        isGameOver = true
        showMenu()
        self.removeAction(forKey: "spawnEnemy")
    
    }

    func showMenu(){
        if score > highScore {
            highScore = score
        }
        
        self.addChild(title)
        self.addChild(playButton)
        self.addChild(highScoreLabel)
    }
    
    func startGame(){
        // spawn player
        player.position = CGPoint(x: size.width / 2, y: 400)
        isPlayerDead = false
        self.addChild(player)
        self.addChild(scoreLabel)

        // reset game over
        isGameOver = false
        isPlayerDead = false
        // reset game score
        score = 0
        // remove play button n high score label
        self.title.removeFromParent()
        self.playButton.removeFromParent()
        self.highScoreLabel.removeFromParent()
        
        spawnEndlessEnemy()
    }
    
}
