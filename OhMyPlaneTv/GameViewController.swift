//
//  GameViewController.swift
//  OhMyPlaneTv
//
//  Created by HS Song on 2016. 4. 13..
//  Copyright (c) 2016년 softdevstory. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = MainScene(size: GameSetting.SceneSize)
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        let skView = self.view as! SKView
        let scene = skView.scene!
        
        if scene is MainScene {
            for press in presses {
                if press.type == .Menu {
                    super.pressesBegan(presses, withEvent: event)
                    return
                }
            }
        }
        
        scene.pressesBegan(presses, withEvent: event)
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        let skView = self.view as! SKView
        let scene = skView.scene!

        scene.pressesEnded(presses, withEvent: event)
    }
}
