//
//  CreditScene+TVControlsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 14..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit

private let fadeOut = SKAction.fadeAlphaTo(0.5, duration: 0.5)
private let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.5)

extension CreditScene: TVControlsScene {
    func setupTVControls() {
        backSprite.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeOut, fadeIn])))
    }
    
    func touchOnRemoteBegan() {
        // nothing to do
    }
    
    func resetTVControls() {
        // nothing to do
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                touchDownBack()
                
            case .Menu:
                touchDownBack()
                
            default:
                break
            }
        }
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if backPressed {
            doBack()
        }
    }
}
