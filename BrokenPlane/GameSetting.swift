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
    static let DeltaRockObstacle: CGFloat = 350
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

enum PlaneType: String {
    case Blue = "blue"
    case Green = "green"
    case Red = "red"
    case Yellow = "yellow"
    
    var boostValue: CGVector {
        switch self {
        case Blue: return CGVector(dx: 0, dy: 1000)
        case Green: return CGVector(dx: 0, dy: 1100)
        case Red: return CGVector(dx: 0, dy: 1200)
        case Yellow: return CGVector(dx: 0, dy: 1300)
        }
    }
    
    var speed: CGFloat {
        switch self {
        case Blue: return 80
        case Green: return 70
        case Red: return 60
        case Yellow: return 50
        }
    }
}

struct SpriteName {
    static let background = "background"
    static let rockObstacle = "rock"
    static let plane = "plane"
}

struct SpriteZPosition {
    static let BackBackground: CGFloat         = -300
    static let RockObstacle: CGFloat           = -200
    static let FrontBackground: CGFloat        = -100
    static let Plane: CGFloat                  = 0
    static let Item: CGFloat                   = 100
    static let Hud: CGFloat                    = 200
    static let Overlay: CGFloat                = 300
}