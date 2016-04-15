//
//  GameScene+TVControlsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 14..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

private var activeNodes: [SKNode] = []
private var currentNodeIndex = 0

private let fadeOut = SKAction.fadeAlphaTo(0.5, duration: 0.5)
private let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.5)

extension GameScene: TVControlsScene {

    
    func setupTVControls() {
        activeNodes = []

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.didSwipeOnRemote(_:)))
        swipeLeft.direction = .Left
        swipeLeft.delaysTouchesBegan = true
        view!.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.didSwipeOnRemote(_:)))
        swipeRight.direction = .Right
        swipeRight.delaysTouchesBegan = true
        view!.addGestureRecognizer(swipeRight)
    }
    
    func resetTVControls() {
        activeNodes = []
        currentNodeIndex = 0
        
        switch gameState.currentState {
            
        case is PlayGame:
            pauseButton.hidden = true

        case is PauseGame:

            activeNodes.append(returnButton)
            activeNodes.append(exitButton)
            
            selectNodeAtIndex(0)
            
        default:
            break
        }

    }
    
    func touchOnRemoteBegan() {
        switch gameState.currentState {
        case is ReadyGame:
            changeGameState(PlayGame.self)
            
        case is FailGame:
            changeGameState(ReadyGame.self)
            
        case is PlayGame:
            goUpPlane()

        case is PauseGame:
            guard activeNodes.count > 0 else {
                return
            }

            let node = activeNodes[currentNodeIndex] as! SKSpriteNode
            if node == returnButton {
                touchDownReturn()
            } else {
                touchDownExit()
            }
            
        default:
            break
        }
    }
    
    func didSwipeOnRemote(swipe: UISwipeGestureRecognizer) {
        guard activeNodes.count > 0 else {
            return
        }
        
        var newIndexToSelect = currentNodeIndex
        if swipe.direction == .Right {
            newIndexToSelect += 1
        } else {
            newIndexToSelect -= 1
        }
        
        if newIndexToSelect < 0 {
            newIndexToSelect = activeNodes.count - 1
        } else if newIndexToSelect > activeNodes.count - 1 {
            newIndexToSelect = 0
        }
        
        selectNodeAtIndex(newIndexToSelect)
    }
    
    func selectNodeAtIndex(index: Int) {
        guard activeNodes.count > 0 else {
            return
        }
        
        activeNodes[index].runAction(SKAction.repeatActionForever(SKAction.sequence([fadeOut, fadeIn])))
        
        if currentNodeIndex < activeNodes.count && index != currentNodeIndex, let node = activeNodes[currentNodeIndex] as? SKSpriteNode {
            node.removeAllActions()
            node.alpha = 1.0
        }
        
        currentNodeIndex = index
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        switch gameState.currentState {
        case is PlayGame:
            for press in presses {
                if press.type == .PlayPause {
                    touchDownPause()
                }
            }
        default:
            break
        }
    }
}
