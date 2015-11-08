//
//  MovingDashes.swift
//  Dodge It
//
//  Created by Matthew Curtner on 10/30/15.
//  Copyright © 2015 Matthew Curtner. All rights reserved.
//

import SpriteKit

class MovingDashes: SKSpriteNode {
    
    let kNumberOfSegments = 12
    let color1 = SKColor.whiteColor()
    let color2 = SKColor.clearColor()
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height * 2))
        anchorPoint = CGPointMake(0.5, 0)
        
        for var i = 0; i < kNumberOfSegments; i++ {
            var segmentColor: UIColor!
            
            if i % 2 == 0 {
                segmentColor = color1
            } else {
                segmentColor = color2
            }
            let segment = SKSpriteNode(color: segmentColor, size: CGSizeMake(frame.size.width, frame.size.height / CGFloat(kNumberOfSegments)))
            segment.anchorPoint = CGPointMake(0.5, 0)
            segment.position = CGPointMake(self.frame.size.width/2 - 2, CGFloat(i) * segment.size.height)
            addChild(segment)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func startAnimatingDashes() {
        let moveDown = SKAction.moveToY(-frame.size.height/2, duration: 2.0)
        let resetPos = SKAction.moveToY(0, duration: 0)
        let sequence = SKAction.sequence([moveDown, resetPos])
        
        runAction(SKAction.repeatActionForever(sequence))
    }

    func stopAnimatingDashes() {
        removeAllActions()
    }
    
}
