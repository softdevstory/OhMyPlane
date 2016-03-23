//
//  PlaneEntity.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PlaneType: String {
    case Blue = "blue"
    case Green = "green"
    case Red = "red"
    case Yellow = "yellow"
}

class PlaneEntity: GKEntity {
    let planeType: PlaneType
    var spriteComponent: SpriteComponent!

    init(planeType: PlaneType) {
        self.planeType = planeType
        super.init()
        
        let textureAtlas = SKTextureAtlas(named: "plane")
        let defaultTexture = textureAtlas.textureNamed("plane_\(planeType.rawValue)_01")
        
        spriteComponent = SpriteComponent(entity: self, texture: defaultTexture, size: defaultTexture.size())
        addComponent(spriteComponent)
    }
}