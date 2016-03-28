//
//  Landing.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import GameplayKit
import SpriteKit

class Landing: GKState {
    unowned let planeEntity: PlaneEntity
    
    init(planeEntity: PlaneEntity) {
        self.planeEntity = planeEntity
        
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        /* physics dynamic false, landing, smoke on */
        planeEntity.showSmoke()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}