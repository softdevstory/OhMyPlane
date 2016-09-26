//
//  Broken.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

class Broken: GKState {
    unowned let planeEntity: PlaneEntity
    
    init(planeEntity: PlaneEntity) {
        self.planeEntity = planeEntity
        
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        /* physics dynamic true, flying, smoke on */
        planeEntity.enableFalling()
        planeEntity.fly()
        planeEntity.showSmoke()
    }
}
