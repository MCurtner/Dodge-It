//
//  GameScene.swift
//  Dodge It
//
//  Created by Matthew Curtner on 10/30/15.
//  Copyright (c) 2015 Matthew Curtner. All rights reserved.
//

import SpriteKit

struct SpriteLayers {
    static let Background: CGFloat = -1
    static let Road: CGFloat = 0
    static let RoadDashes: CGFloat = 1
    static let Coins: CGFloat = 2
    static let Cars: CGFloat = 3
    static let PlayerCar: CGFloat = 4
    static let HUD: CGFloat = 5
    static let HUDData: CGFloat = 6
}

struct PhysicsCategory {
    static let Coin: UInt32 = 1
    static let PlayerCar: UInt32 = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: -  Constants
    let kPointsPerCoin: Int = 100
    
    // MARK: - Game Variables
    
    var movingCenterDashes: MovingDashes!
    var playerCar: SKSpriteNode!
    var coin: SKSpriteNode!
    var kDownwardSpeed: CGFloat = 3.0
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var myUtils = MyUtils()
    var hud: SKSpriteNode!
    var pointsLabel: SKLabelNode!
    var pointsValue: Int = 0

    
    // MARK: - Game Scene
    
    override func didMoveToView(view: SKView) {
        
        // Set Physics delegate to self
        physicsWorld.contactDelegate = self
        
        // Setup Coin Texture Atlas
        addImagesToArrayFromTextureAtlas()
        
        // Setup the game
        setupHUD()
        setupBackground()
        setupRoad()
        setupPlayerCar()
        setupCoins()
    }
    
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            // Not allowing the player car to pass the width of the street
            if location.x < frame.size.width/2 {
                playerCar.runAction(SKAction.moveToX(frame.size.width/2 - 32, duration: 0.5))
            }
            if location.x > frame.size.width/2 {
                playerCar.runAction(SKAction.moveToX(frame.size.width/2 + 32, duration: 0.5))
            }
        }
    }
   
    // MARK: - Update
    
    override func update(currentTime: CFTimeInterval) {
        
        coin.position.y -= 4
        
        if coin.position.y < -frame.size.height {
            coin.removeFromParent()
            setupCoins()
        }
    
    }
    
    // MARK: - HUD
    func setupHUD() {
        hud = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSizeMake(frame.size.width, frame.size.height / 16))
        hud.position = CGPoint(x: frame.size.width/2, y: frame.size.height - hud.size.height/2)
        hud.zPosition = SpriteLayers.HUD
        
        hudPoints()
        
        addChild(hud)
    }
    
    func hudPoints() {
        pointsLabel = SKLabelNode(text: "000")
        pointsLabel.fontColor = SKColor.whiteColor()
        pointsLabel.fontSize = 50
        pointsLabel.zPosition = SpriteLayers.HUDData
        pointsLabel.position = CGPoint(x: hud.position.x, y: hud.position.y - 20)
        
        addChild(pointsLabel)
    }
    
    
    // MARK: - Background Elements
    
    func setupBackground() {
        let background = SKSpriteNode(texture: nil, color: UIColor.greenColor(), size: CGSize(width: frame.size.width, height: frame.size.height))
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        //background.color = SKColor.greenColor()
        background.zPosition = SpriteLayers.Background
        
        addChild(background)
    }
    
    
    func setupRoad() {
        let road = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 128.0, height: frame.size.height))
        road.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        road.zPosition = SpriteLayers.Road
        
        setupRoadSides(xPosition: (frame.size.width/2) - 64)
        setupRoadSides(xPosition: (frame.size.width/2) + 64)
        
        setupCenterDashes()
        
        addChild(road)
    }
    
    func setupRoadSides(xPosition xPosition: CGFloat) {
        let whiteMargin = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 5.0, height: frame.size.height))
        whiteMargin.position = CGPoint(x: xPosition, y: frame.size.height/2)
        whiteMargin.zPosition = SpriteLayers.Road
        
        addChild(whiteMargin)
    }
    
    func setupCenterDashes() {
        movingCenterDashes = MovingDashes(size: CGSizeMake(5, frame.size.height))
        movingCenterDashes.anchorPoint = CGPointMake(0.5, 0)
        movingCenterDashes.position = CGPointMake(frame.size.width/2, 0)
        movingCenterDashes.zPosition = SpriteLayers.RoadDashes
        addChild(movingCenterDashes)
        
        movingCenterDashes.startAnimatingDashes()
    }
    
    // MARK: -  Player Car

    func setupPlayerCar() {
        playerCar = SKSpriteNode(imageNamed: "Car")
        playerCar.size = CGSizeMake(128.0, 128.0)
        playerCar.position = CGPoint(x: frame.size.width/2 + 32, y: frame.size.height/2)
        playerCar.zPosition = SpriteLayers.PlayerCar
        playerCar.name = "playerCar"
        
        // Player Car Physics
        playerCarPhysics()
        
        addChild(playerCar)
    }

    
    // MARK: - Coins

    // Add texture atlas images to the textureArray
    func addImagesToArrayFromTextureAtlas() {
        textureAtlas = SKTextureAtlas(named: "Coins")
        
        // Add images to textureArray
        for i in 1...textureAtlas.textureNames.count {
            let name = "coin\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
        }
    }
    
    func setupCoins() {
        let randomX = myUtils.getRandomness(zeroToValue: 2)
        let randomY = myUtils.getRandomness(zeroToValue: frame.size.height * 2)
        
        // Coin SpriteNode
        coin = SKSpriteNode(imageNamed: textureAtlas.textureNames[0])
        coin.size = CGSize(width: 50, height: 50)
        coin.zPosition = SpriteLayers.Coins
        coin.name = "coin"
        
        // Determine which lane the coin will be in
        if randomX == 0 {
            coin.position = CGPoint(x: frame.size.width/2 - 32, y: randomY + frame.size.height)
        }
        if randomX == 1 {
            coin.position = CGPoint(x: frame.size.width/2 + 32, y: randomY + frame.size.height)
        }
        
        coinPhysics()
        
        addChild(coin)
        
        // Animate the spinning of the coin
        coin.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textureArray, timePerFrame: 0.09)))
    }
    
    // MARK: - Physics
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.PlayerCar && secondBody.categoryBitMask == PhysicsCategory.Coin {
            print("Collision between player car and coin occurred")
            collisionWithCoin(PlayerCar: firstBody.node as! SKSpriteNode, Coin: secondBody.node as! SKSpriteNode)
            
            // Update HUD Points
            pointsValue += kPointsPerCoin
            pointsLabel.text = String(pointsValue)
            
        }
    }
    
    func playerCarPhysics() {
        playerCar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 40.0, height: playerCar.size.height - 30))
        playerCar.physicsBody?.affectedByGravity = false
        playerCar.physicsBody?.categoryBitMask = PhysicsCategory.PlayerCar
        playerCar.physicsBody?.contactTestBitMask = PhysicsCategory.Coin
        playerCar.physicsBody?.dynamic = true
    }
    
    func coinPhysics() {
        coin.physicsBody = SKPhysicsBody(rectangleOfSize: coin.frame.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerCar
        coin.physicsBody?.dynamic = false
    }
    
    func collisionWithCoin(PlayerCar PlayerCar:SKSpriteNode, Coin: SKSpriteNode) {
        coin.removeFromParent()
//        let coinSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false)
//        runAction(coinSound)
    }
    
 }
