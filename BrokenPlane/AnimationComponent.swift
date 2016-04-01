//
//  AnimationComponent.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

enum AnimationState: String {
    case Flying = "Flying"
}

struct Animation {
    let animationState: AnimationState
    let textures: [SKTexture]
    let repeatTexturesForever: Bool
}

class AnimationComponent: GKComponent {
    let node: SKSpriteNode
    
    var animations: [AnimationState: Animation]
    
    private var currentAnimation: Animation?
    
    var requestedAnimationState: AnimationState?
    
    init(node: SKSpriteNode, animations: [AnimationState: Animation]) {
        self.node = node
        self.animations = animations
        
        super.init()
    }
    
    private func runAnimationForAnimationState(animationState: AnimationState) {
        
        guard let animation = animations[animationState] else {
            print("Unknown animation for state \(animationState.rawValue)")
            return
        }
        
        if currentAnimation != nil &&
            currentAnimation!.animationState == animationState {
            return
        }

        let actionKey = "Animation"
        let timePerFrame = NSTimeInterval(1.0 / 30)
        
        node.removeActionForKey(actionKey)
        
        let texturesAction: SKAction
        if animation.repeatTexturesForever {
            texturesAction = SKAction.repeatActionForever(
                SKAction.animateWithTextures(animation.textures, timePerFrame: timePerFrame))
        } else {
            texturesAction = SKAction.animateWithTextures(animation.textures, timePerFrame: timePerFrame)
        }
        node.runAction(texturesAction, withKey: actionKey)
        
        currentAnimation = animation
    }
    
    class func animationFromAtlas(atlasTexture: SKTextureAtlas, withImageIdentifier identifier: String, forAnimationState animationState: AnimationState, repeatTexturesForever: Bool) -> Animation {
        let textures = atlasTexture.textureNames.filter {
            $0.hasPrefix("\(identifier)")
            }.sort {
                $0 < $1
            }.map {
                atlasTexture.textureNamed($0)
        }
        
        return Animation(animationState: animationState, textures: textures, repeatTexturesForever: repeatTexturesForever)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        if let animationState = requestedAnimationState {
            runAnimationForAnimationState(animationState)
            requestedAnimationState = nil
        }
    }
}