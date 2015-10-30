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
}

class GameScene: SKScene {

    
    var movingCenterDashes: MovingDashes!
    
    override func didMoveToView(view: SKView) {
        setupBackground()
        setupRoad()
        
        movingCenterDashes = MovingDashes(size: CGSizeMake(5, frame.size.height))
        movingCenterDashes.anchorPoint = CGPointMake(0.5, 0)
        movingCenterDashes.position = CGPointMake(frame.size.width/2, 0)
        movingCenterDashes.zPosition = SpriteLayers.RoadDashes
        addChild(movingCenterDashes)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        movingCenterDashes.startAnimatingDashes()
    }
   
    override func update(currentTime: CFTimeInterval) {
    
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
                
        addChild(road)
    }
    
    func setupRoadSides(xPosition xPosition: CGFloat) {
        let whiteMargin = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 5.0, height: frame.size.height))
        whiteMargin.position = CGPoint(x: xPosition, y: frame.size.height/2)
        whiteMargin.zPosition = SpriteLayers.Road
        
        addChild(whiteMargin)
    }
    
 }
