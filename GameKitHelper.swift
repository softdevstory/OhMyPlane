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

    fileprivate override init() {
        super.init()
    }
    
    var authenticationViewController: UIViewController?
    var gameCenterEnabled = false
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer()
        localPlayer.authenticateHandler = { (viewController, error) in
            if viewController != nil {
                self.authenticationViewController = viewController

                NotificationCenter.default.post(name: Notification.Name(rawValue: PresentAuthenticationViewController), object: self)
            } else if error == nil {
                self.gameCenterEnabled = true
            } else {
                print("Game center error: \(error)")
            }
        }
    }
    
    func showGKGameCenterViewController(_ viewController: UIViewController) {
        guard gameCenterEnabled else {
            return
        }
        
        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
    
        viewController.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    func reportAchievements(_ achievements: [GKAchievement], errorHandler: ((NSError?) -> Void)? = nil) {
        guard gameCenterEnabled else {
            return
        }
        
        GKAchievement.report(achievements, withCompletionHandler: errorHandler as! ((Error?) -> Void)?)
    }
    
    func reportScore(_ gkScore: GKScore, errorHandler: ((NSError?)->Void)? = nil) {
        guard gameCenterEnabled else {
            return
        }
        
        GKScore.report([gkScore], withCompletionHandler: errorHandler as! ((Error?) -> Void)?)
    }
}


extension GameKitHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
