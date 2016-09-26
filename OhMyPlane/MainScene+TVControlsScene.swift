//
//  MainScene+TVControlsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 14..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit

private var activeNodes: [SKNode] = []
private var currentNodeIndex = 0

private let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
private let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)

extension MainScene: TVControlsScene {
    
    func setupTVControls() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MainScene.didSwipeOnRemote(_:)))
        swipeLeft.direction = .left
        swipeLeft.delaysTouchesBegan = true
        view!.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MainScene.didSwipeOnRemote(_:)))
        swipeRight.direction = .right
        swipeRight.delaysTouchesBegan = true
        view!.addGestureRecognizer(swipeRight)

        activeNodes = []
        
        activeNodes.append(startSprite)
        activeNodes.append(setupSprite)
        activeNodes.append(topRecordsSprite)
        
        selectNodeAtIndex(0)
    }
    
    func touchOnRemoteBegan() {
        // nothing to do
    }
    
    func resetTVControls() {
        // nothing to do
    }

    func didSwipeOnRemote(_ swipe: UISwipeGestureRecognizer) {
        var newIndexToSelect = currentNodeIndex
        if swipe.direction == .right {
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
    
    func selectNodeAtIndex(_ index: Int) {
        activeNodes[index].run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
        
        if currentNodeIndex < activeNodes.count && index != currentNodeIndex, let node = activeNodes[currentNodeIndex] as? SKSpriteNode {
            node.removeAllActions()
            node.alpha = 1.0
        }
        
        currentNodeIndex = index
    }
    
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for press in presses {
            switch press.type {
            case .select:
                let node = activeNodes[currentNodeIndex] as! SKSpriteNode
                
                switch node {
                case startSprite:
                    touchDownStart()
                case setupSprite:
                    touchDownSetup()
                case topRecordsSprite:
                    touchDownTopRecord()
                default:
                    break
                }
                
            case .menu:
                exit(0)
                break
                
            default:
                break
                
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

        if startPressed {
            let transition = SKTransition.fade(withDuration: 0.6)
            view!.presentScene(gameScene, transition: transition)
            
            touchUpStart()
        }
        
        if setupPressed {
            let transition = SKTransition.push(with: .down, duration: 0.6)
            view!.presentScene(creditScene, transition: transition)
            
            touchUpSetup()
        }
        
        if topRecordsPressed {
            let transition = SKTransition.push(with: .up, duration: 0.6)
            view!.presentScene(topRecordsScene, transition: transition)
            
            touchUpTopRecord()
        }
    }
}
