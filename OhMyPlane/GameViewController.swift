//
//  GameViewController.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 23..
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
//        skView.showsPhysics = true
        
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
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        if let authenticationViewController = gameKitHelper.authenticationViewController {
            presentViewController(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    func showGameCenterViewController() {
        GameKitHelper.sharedInstance.showGKGameCenterViewController(self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
