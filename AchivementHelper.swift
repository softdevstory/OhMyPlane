//
//  AchivementHelper.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 25..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import Foundation
import GameKit


enum Achievement: String {
    case RedPlane50
    case RedPlane100
    case RedPlane150
    case RedPlaneBronzeMedal
    case RedPlaneSilverMedal
    case RedPlaneGoldMedal
    case YellowPlane50
    case YellowPlane100
    case YellowPlane150
    case YellowPlaneBronzeMedal
    case YellowPlaneSilverMedal
    case YellowPlaneGoldMedal
    case GreenPlane50
    case GreenPlane100
    case GreenPlane150
    case GreenPlaneBronzeMedal
    case GreenPlaneSilverMedal
    case GreenPlaneGoldMedal
    case BluePlane50
    case BluePlane100
    case BluePlane150
    case BluePlaneBronzeMedal
    case BluePlaneSilverMedal
    case BluePlaneGoldMedal
    case GoldMedal5
    case GoldMedal10
    case GoldMedal15
    case SilverMedal10
    case SilverMedal15
    case SilverMedal20
    case BronzeMedal10
    case BronzeMedal15
    case BronzeMedal20
    case Flight50
    case Flight100
    case Flight150
    case CreditWatch
    
    private func getPercentage(gameStatistic: GameStatistics, maxValue: Double) -> Double {
        let percent: Double = (Double(gameStatistic.getValue()) / maxValue) * 100.0
        if percent > 100.0 {
            return 100.0
        }

        return percent
    }
    
    var gkAchievement: GKAchievement {
        let bundleId = NSBundle.mainBundle().bundleIdentifier!
        let achievement = GKAchievement(identifier: "\(bundleId).\(self.rawValue)")

        switch self {
        case RedPlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountRedPlane, maxValue: 50.0)
        case RedPlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountRedPlane, maxValue: 100.0)
        case RedPlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountRedPlane, maxValue: 150.0)
            
        case YellowPlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountYellowPlane, maxValue: 50.0)
        case YellowPlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountYellowPlane, maxValue: 100.0)
        case YellowPlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountYellowPlane, maxValue: 150.0)
            
        case GreenPlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountGreenPlane, maxValue: 50.0)
        case GreenPlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountGreenPlane, maxValue: 100.0)
        case GreenPlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountGreenPlane, maxValue: 150.0)
            
        case BluePlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountBluePlane, maxValue: 50.0)
        case BluePlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountBluePlane, maxValue: 100.0)
        case BluePlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountBluePlane, maxValue: 150.0)
            
        case GoldMedal5:
            achievement.percentComplete = getPercentage(GameStatistics.goldMedalCount, maxValue: 5.0)
        case GoldMedal10:
            achievement.percentComplete = getPercentage(GameStatistics.goldMedalCount, maxValue: 10.0)
        case GoldMedal15:
            achievement.percentComplete = getPercentage(GameStatistics.goldMedalCount, maxValue: 15.0)
            
        case SilverMedal10:
            achievement.percentComplete = getPercentage(GameStatistics.silverMedalCount, maxValue: 10.0)
        case SilverMedal15:
            achievement.percentComplete = getPercentage(GameStatistics.silverMedalCount, maxValue: 15.0)
        case SilverMedal20:
            achievement.percentComplete = getPercentage(GameStatistics.silverMedalCount, maxValue: 20.0)
            
        case BronzeMedal10:
            achievement.percentComplete = getPercentage(GameStatistics.bronzeMedalCount, maxValue: 10.0)
        case BronzeMedal15:
            achievement.percentComplete = getPercentage(GameStatistics.bronzeMedalCount, maxValue: 15.0)
        case BronzeMedal20:
            achievement.percentComplete = getPercentage(GameStatistics.bronzeMedalCount, maxValue: 20.0)
            
        case Flight50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCount, maxValue: 50.0)
        case Flight100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCount, maxValue: 100.0)
        case Flight150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCount, maxValue: 150.0)

        default:
            break
        }
        
        return achievement
    }
}

class AchievementHelper {
    static let sharedInstance = AchievementHelper()

    private init() {
        // for singleton pattern
    }
    
    func creditWatchAchievement() -> GKAchievement {
        let achievement = Achievement.CreditWatch.gkAchievement
        
        achievement.percentComplete = 100.0
        achievement.showsCompletionBanner = true
        
        return achievement
    }
    
    func createAchievements(planeType: PlaneType, medalType: Rank) -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        let flight = flightAchievements()
        achievements.appendContentsOf(flight)

        let planeFlight = planeFlightAchievements(planeType)
        achievements.appendContentsOf(planeFlight)
        
        if medalType != .None {
            let medal = medalAchievements(medalType)
            achievements.appendContentsOf(medal)
            
            if let planeMedal = planeMedalAchievement(planeType, medalType: medalType) {
                achievements.append(planeMedal)
            }
        }

        return achievements
    }
    
    private func planeMedalAchievement(planeType: PlaneType, medalType: Rank) -> GKAchievement? {
        var achievement: GKAchievement? = nil
        
        switch planeType {
        case .Red:
            switch medalType {
            case .Gold:
                achievement = Achievement.RedPlaneGoldMedal.gkAchievement
            case .Silver:
                achievement = Achievement.RedPlaneSilverMedal.gkAchievement
            case .Bronze:
                achievement = Achievement.RedPlaneBronzeMedal.gkAchievement
            default: break
            }
            
        case .Blue:
            switch medalType {
            case .Gold:
                achievement = Achievement.BluePlaneGoldMedal.gkAchievement
            case .Silver:
                achievement = Achievement.BluePlaneSilverMedal.gkAchievement
            case .Bronze:
                achievement = Achievement.BluePlaneBronzeMedal.gkAchievement
            default: break
            }

        case .Green:
            switch medalType {
            case .Gold:
                achievement = Achievement.GreenPlaneGoldMedal.gkAchievement
            case .Silver:
                achievement = Achievement.GreenPlaneSilverMedal.gkAchievement
            case .Bronze:
                achievement = Achievement.GreenPlaneBronzeMedal.gkAchievement
            default: break
            }

        case .Yellow:
            switch medalType {
            case .Gold:
                achievement = Achievement.YellowPlaneGoldMedal.gkAchievement
            case .Silver:
                achievement = Achievement.YellowPlaneSilverMedal.gkAchievement
            case .Bronze:
                achievement = Achievement.YellowPlaneBronzeMedal.gkAchievement
            default: break
            }
        }
        
        if achievement != nil {
            achievement!.percentComplete = 100.0
            achievement!.showsCompletionBanner = true
        }
        
        return achievement
    }
    
    private func goldMedalAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.GoldMedal5.gkAchievement)
        achievements.append(Achievement.GoldMedal10.gkAchievement)
        achievements.append(Achievement.GoldMedal15.gkAchievement)

        return achievements
    }

    private func silverMedalAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.SilverMedal10.gkAchievement)
        achievements.append(Achievement.SilverMedal15.gkAchievement)
        achievements.append(Achievement.SilverMedal20.gkAchievement)
        
        return achievements
    }

    private func bronzeMedalAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
     
        achievements.append(Achievement.BronzeMedal10.gkAchievement)
        achievements.append(Achievement.BronzeMedal15.gkAchievement)
        achievements.append(Achievement.BronzeMedal20.gkAchievement)

        return achievements
    }

    private func medalAchievements(medalType: Rank) -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        guard medalType != .None else {
            return achievements
        }

        switch medalType {
        case .Gold:
            achievements.appendContentsOf(goldMedalAchievements())
            
        case .Silver:
            achievements.appendContentsOf(silverMedalAchievements())
            
        case .Bronze:
            achievements.appendContentsOf(bronzeMedalAchievements())
            
        default: break
        }
        
        return achievements
    }
    
    private func flightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.Flight50.gkAchievement)
        achievements.append(Achievement.Flight100.gkAchievement)
        achievements.append(Achievement.Flight150.gkAchievement)
        
        return achievements
    }
    
    private func redPlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.RedPlane50.gkAchievement)
        achievements.append(Achievement.RedPlane100.gkAchievement)
        achievements.append(Achievement.RedPlane150.gkAchievement)

        return achievements
    }

    private func bluePlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        achievements.append(Achievement.BluePlane50.gkAchievement)
        achievements.append(Achievement.BluePlane100.gkAchievement)
        achievements.append(Achievement.BluePlane150.gkAchievement)

        return achievements
    }

    private func yellowPlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        achievements.append(Achievement.YellowPlane50.gkAchievement)
        achievements.append(Achievement.YellowPlane100.gkAchievement)
        achievements.append(Achievement.YellowPlane150.gkAchievement)

        return achievements
    }

    private func greenPlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        achievements.append(Achievement.GreenPlane50.gkAchievement)
        achievements.append(Achievement.GreenPlane100.gkAchievement)
        achievements.append(Achievement.GreenPlane150.gkAchievement)

        return achievements
    }

    private func planeFlightAchievements(planeType: PlaneType) -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        switch planeType {
        case .Red:
            achievements.appendContentsOf(redPlaneFlightAchievements())
            
        case .Blue:
            achievements.appendContentsOf(bluePlaneFlightAchievements())
            
        case .Yellow:
            achievements.appendContentsOf(yellowPlaneFlightAchievements())

        case .Green:
            achievements.appendContentsOf(greenPlaneFlightAchievements())
        }
        
        return achievements
    }
}
