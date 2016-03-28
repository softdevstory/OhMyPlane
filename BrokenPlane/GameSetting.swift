//
//  GameSetting.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit

struct GameSetting {
    static let PhysicsGravity = CGVector(dx: 0, dy: -9)
}

enum BackgroundType: String {
    case Dirt = "dirt"
    case Grass = "grass"
    case Ice = "ice"
    case Rock = "rock"
    case Snow = "snow"
    
    var imageFileName: String {
        return "background_\(self.rawValue)"
    }
}

enum SpriteLayer: Int {
    case BackBackground     = 0
    case RockObstacle
    case FrontBackground
    case Plane
    case Item
    case Hud
    case Overlay
    
    var zPosition: CGFloat {
        switch self {
        case BackBackground: return -300
        case RockObstacle: return -200
        case FrontBackground: return -100
        case Plane: return 0
        case Item: return 0
        case Hud: return 100
        case Overlay: return 200
        }
    }
}