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
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)

        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showAuthenticationViewController), name: NSNotification.Name(rawValue: PresentAuthenticationViewController), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showGameCenterViewController), name: NSNotification.Name(rawValue: PresentGameCenterViewController), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
