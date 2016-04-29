//
//  GameKitHelper.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 25..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import Foundation
import UIKit
import GameKit

let PresentAuthenticationViewController = "PresentAuthenticationViewController"
let PresentGameCenterViewController = "PresentGameCenterViewController"

class GameKitHelper: NSObject {
    static let sharedInstance = GameKitHelper()

    private override init() {
        super.init()
    }
    
    var authenticationViewController: UIViewController?
    var gameCenterEnabled = false
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer()
        localPlayer.authenticateHandler = { (viewController, error) in
            if viewController != nil {
                self.authenticationViewController = viewController

                NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController, object: self)
            } else if error == nil {
                self.gameCenterEnabled = true
            } else {
                print("Game center error: \(error)")
            }
        }
    }
    
    func showGKGameCenterViewController(viewController: UIViewController) {
        guard gameCenterEnabled else {
            return
        }
        
        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
    
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func reportAchievements(achievements: [GKAchievement], errorHandler: ((NSError?) -> Void)? = nil) {
        guard gameCenterEnabled else {
            return
        }
        
        GKAchievement.reportAchievements(achievements, withCompletionHandler: errorHandler)
    }
    
    func reportScore(gkScore: GKScore, errorHandler: ((NSError?)->Void)? = nil) {
        guard gameCenterEnabled else {
            return
        }
        
        GKScore.reportScores([gkScore], withCompletionHandler: errorHandler)
    }
}


extension GameKitHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}