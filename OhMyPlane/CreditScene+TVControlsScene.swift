//
//  CreditScene+TVControlsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 14..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit

private let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
private let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)

extension CreditScene: TVControlsScene {
    func setupTVControls() {
        backSprite.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
    }
    
    func touchOnRemoteBegan() {
        // nothing to do
    }
    
    func resetTVControls() {
        // nothing to do
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .select:
                touchDownBack()
                
            case .menu:
                touchDownBack()
                
            default:
                break
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if backPressed {
            doBack()
        }
    }
}
