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
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showAuthenticationViewController), name: NSNotification.Name(rawValue: PresentAuthenticationViewController), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showGameCenterViewController), name: NSNotification.Name(rawValue: PresentGameCenterViewController), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        let skView = self.view as! SKView
        let scene = skView.scene!

        if !(scene is GameScene) {
            for press in presses {
                if press.type == .menu {
                    super.pressesBegan(presses, with: event)
                    return
                }
            }
        }
        
        scene.pressesBegan(presses, with: event)
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        let skView = self.view as! SKView
        let scene = skView.scene!
        
        if !(scene is GameScene) {
            for press in presses {
                if press.type == .menu {
                    super.pressesEnded(presses, with: event)
                    return
                }
            }
        }

        scene.pressesEnded(presses, with: event)
    }
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        if let authenticationViewController = gameKitHelper.authenticationViewController {
            present(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    func showGameCenterViewController() {
        GameKitHelper.sharedInstance.showGKGameCenterViewController(self)
    }
}
