//
//  MyUtils.swift
//  Dodge It
//
//  Created by Matthew Curtner on 10/30/15.
//  Copyright © 2015 Matthew Curtner. All rights reserved.
//

import SpriteKit

class MyUtils {
    
    // Return the random value between 0 and the provided parameter
    func getRandomness(zeroToValue zeroToValue: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(zeroToValue)))
    }
    
}