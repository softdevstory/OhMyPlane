//
//  TopRecordsScene+TVControlsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 14..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit

private let fadeOut = SKAction.fadeAlphaTo(0.5, duration: 0.5)
private let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.5)

extension TopRecordsScene: TVControlsScene {
    func setupTVControls() {
        backSprite.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeOut, fadeIn])))
    }
    
    func touchOnRemoteBegan() {
        touchDownBack()
    }
    
    func resetTVControls() {
        // nothing to do 
    }
}
