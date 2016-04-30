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
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.showAuthenticationViewController), name: PresentAuthenticationViewController, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.showGameCenterViewController), name: PresentGameCenterViewController, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        let skView = self.view as! SKView
        let scene = skView.scene!

        if !(scene is GameScene) {
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
        
        if !(scene is GameScene) {
            for press in presses {
                if press.type == .Menu {
                    super.pressesEnded(presses, withEvent: event)
                    return
                }
            }
        }

        scene.pressesEnded(presses, withEvent: event)
    }
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        if let authenticationViewController = gameKitHelper.authenticationViewController {
            presentViewController(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    func showGameCenterViewController() {
        GameKitHelper.sharedInstance.showGKGameCenterViewController(self)
    }
}
