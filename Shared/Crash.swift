//
//  Crash.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import GameplayKit
import SpriteKit

class Crash: GKState {
    unowned let planeEntity: PlaneEntity
    
    init(planeEntity: PlaneEntity) {
        self.planeEntity = planeEntity
        
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        /* physics dynamic true, stop, smoke on, explosion */
        planeEntity.enableFalling()
        planeEntity.showSmoke()
        planeEntity.stopFlying()
        
        planeEntity.explosion()
    }

}
