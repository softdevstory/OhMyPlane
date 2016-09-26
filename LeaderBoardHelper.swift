//
//  LeaderBoardHelper.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 28..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import Foundation
import GameKit

enum LeaderBoard: String {
    case RedPlaneHighScore
    case BluePlaneHighScore
    case YellowPlaneHighScore
    case GreenPlaneHighScore
    
    var gkScore: GKScore {
        let bundleId = Bundle.main.bundleIdentifier!
        return GKScore(leaderboardIdentifier: "\(bundleId).\(self.rawValue)")
    }
}

class LeaderBoardHelper {
    static let sharedInstance = LeaderBoardHelper()
    
    fileprivate init() {
        // for singleton pattern
    }
    
    func createScore(_ planeType: PlaneType, score: Int) -> GKScore {
        var gkScore: GKScore!
        
        switch planeType {
        case .Red:
            gkScore = LeaderBoard.RedPlaneHighScore.gkScore
        case .Yellow:
            gkScore = LeaderBoard.YellowPlaneHighScore.gkScore
        case .Blue:
            gkScore = LeaderBoard.BluePlaneHighScore.gkScore
        case .Green:
            gkScore = LeaderBoard.GreenPlaneHighScore.gkScore
        }
        
        gkScore.value = Int64(score)
        
        return gkScore
    }
}
