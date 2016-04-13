//
//  PlaneMovementComponent.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlaneMovementComponent: GKComponent {
    let node: SKSpriteNode
    
    init(node: SKSpriteNode) {
        self.node = node
        
        super.init()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
        /* plane's head */
        if let physicsBody = node.physicsBody {
            let value = physicsBody.velocity.dy * (physicsBody.velocity.dy < 0 ? 0.003 : 0.001)

            node.zRotation = max(min(value, 0.5), -1)
        }
    }
}
