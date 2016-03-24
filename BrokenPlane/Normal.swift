//
//  Normal.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

class Normal: GKState {
    unowned let planeEntity: PlaneEntity
    
    init(planeEntity: PlaneEntity) {
        self.planeEntity = planeEntity
        
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        /* physics dynamic false, flying, no smoke */
    }
}
