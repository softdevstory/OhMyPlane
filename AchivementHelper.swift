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
    
    fileprivate func getPercentage(_ gameStatistic: GameStatistics, maxValue: Double) -> Double {
        let percent: Double = (Double(gameStatistic.getValue()) / maxValue) * 100.0
        if percent > 100.0 {
            return 100.0
        }

        return percent
    }
    
    var gkAchievement: GKAchievement {
        let bundleId = Bundle.main.bundleIdentifier!
        let achievement = GKAchievement(identifier: "\(bundleId).\(self.rawValue)")

        switch self {
        case .RedPlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountRedPlane, maxValue: 50.0)
        case .RedPlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountRedPlane, maxValue: 100.0)
        case .RedPlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountRedPlane, maxValue: 150.0)
            
        case .YellowPlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountYellowPlane, maxValue: 50.0)
        case .YellowPlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountYellowPlane, maxValue: 100.0)
        case .YellowPlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountYellowPlane, maxValue: 150.0)
            
        case .GreenPlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountGreenPlane, maxValue: 50.0)
        case .GreenPlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountGreenPlane, maxValue: 100.0)
        case .GreenPlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountGreenPlane, maxValue: 150.0)
            
        case .BluePlane50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountBluePlane, maxValue: 50.0)
        case .BluePlane100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountBluePlane, maxValue: 100.0)
        case .BluePlane150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCountBluePlane, maxValue: 150.0)
            
        case .GoldMedal5:
            achievement.percentComplete = getPercentage(GameStatistics.goldMedalCount, maxValue: 5.0)
        case .GoldMedal10:
            achievement.percentComplete = getPercentage(GameStatistics.goldMedalCount, maxValue: 10.0)
        case .GoldMedal15:
            achievement.percentComplete = getPercentage(GameStatistics.goldMedalCount, maxValue: 15.0)
            
        case .SilverMedal10:
            achievement.percentComplete = getPercentage(GameStatistics.silverMedalCount, maxValue: 10.0)
        case .SilverMedal15:
            achievement.percentComplete = getPercentage(GameStatistics.silverMedalCount, maxValue: 15.0)
        case .SilverMedal20:
            achievement.percentComplete = getPercentage(GameStatistics.silverMedalCount, maxValue: 20.0)
            
        case .BronzeMedal10:
            achievement.percentComplete = getPercentage(GameStatistics.bronzeMedalCount, maxValue: 10.0)
        case .BronzeMedal15:
            achievement.percentComplete = getPercentage(GameStatistics.bronzeMedalCount, maxValue: 15.0)
        case .BronzeMedal20:
            achievement.percentComplete = getPercentage(GameStatistics.bronzeMedalCount, maxValue: 20.0)
            
        case .Flight50:
            achievement.percentComplete = getPercentage(GameStatistics.flightCount, maxValue: 50.0)
        case .Flight100:
            achievement.percentComplete = getPercentage(GameStatistics.flightCount, maxValue: 100.0)
        case .Flight150:
            achievement.percentComplete = getPercentage(GameStatistics.flightCount, maxValue: 150.0)

        default:
            break
        }
        
        return achievement
    }
}

class AchievementHelper {
    static let sharedInstance = AchievementHelper()

    fileprivate init() {
        // for singleton pattern
    }
    
    func creditWatchAchievement() -> GKAchievement {
        let achievement = Achievement.CreditWatch.gkAchievement
        
        achievement.percentComplete = 100.0
        achievement.showsCompletionBanner = true
        
        return achievement
    }
    
    func createAchievements(_ planeType: PlaneType, medalType: Rank) -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        let flight = flightAchievements()
        achievements.append(contentsOf: flight)

        let planeFlight = planeFlightAchievements(planeType)
        achievements.append(contentsOf: planeFlight)
        
        if medalType != .none {
            let medal = medalAchievements(medalType)
            achievements.append(contentsOf: medal)
            
            if let planeMedal = planeMedalAchievement(planeType, medalType: medalType) {
                achievements.append(planeMedal)
            }
        }

        return achievements
    }
    
    fileprivate func planeMedalAchievement(_ planeType: PlaneType, medalType: Rank) -> GKAchievement? {
        var achievement: GKAchievement? = nil
        
        switch planeType {
        case .Red:
            switch medalType {
            case .gold:
                achievement = Achievement.RedPlaneGoldMedal.gkAchievement
            case .silver:
                achievement = Achievement.RedPlaneSilverMedal.gkAchievement
            case .bronze:
                achievement = Achievement.RedPlaneBronzeMedal.gkAchievement
            default: break
            }
            
        case .Blue:
            switch medalType {
            case .gold:
                achievement = Achievement.BluePlaneGoldMedal.gkAchievement
            case .silver:
                achievement = Achievement.BluePlaneSilverMedal.gkAchievement
            case .bronze:
                achievement = Achievement.BluePlaneBronzeMedal.gkAchievement
            default: break
            }

        case .Green:
            switch medalType {
            case .gold:
                achievement = Achievement.GreenPlaneGoldMedal.gkAchievement
            case .silver:
                achievement = Achievement.GreenPlaneSilverMedal.gkAchievement
            case .bronze:
                achievement = Achievement.GreenPlaneBronzeMedal.gkAchievement
            default: break
            }

        case .Yellow:
            switch medalType {
            case .gold:
                achievement = Achievement.YellowPlaneGoldMedal.gkAchievement
            case .silver:
                achievement = Achievement.YellowPlaneSilverMedal.gkAchievement
            case .bronze:
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
    
    fileprivate func goldMedalAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.GoldMedal5.gkAchievement)
        achievements.append(Achievement.GoldMedal10.gkAchievement)
        achievements.append(Achievement.GoldMedal15.gkAchievement)

        return achievements
    }

    fileprivate func silverMedalAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.SilverMedal10.gkAchievement)
        achievements.append(Achievement.SilverMedal15.gkAchievement)
        achievements.append(Achievement.SilverMedal20.gkAchievement)
        
        return achievements
    }

    fileprivate func bronzeMedalAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
     
        achievements.append(Achievement.BronzeMedal10.gkAchievement)
        achievements.append(Achievement.BronzeMedal15.gkAchievement)
        achievements.append(Achievement.BronzeMedal20.gkAchievement)

        return achievements
    }

    fileprivate func medalAchievements(_ medalType: Rank) -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        guard medalType != .none else {
            return achievements
        }

        switch medalType {
        case .gold:
            achievements.append(contentsOf: goldMedalAchievements())
            
        case .silver:
            achievements.append(contentsOf: silverMedalAchievements())
            
        case .bronze:
            achievements.append(contentsOf: bronzeMedalAchievements())
            
        default: break
        }
        
        return achievements
    }
    
    fileprivate func flightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.Flight50.gkAchievement)
        achievements.append(Achievement.Flight100.gkAchievement)
        achievements.append(Achievement.Flight150.gkAchievement)
        
        return achievements
    }
    
    fileprivate func redPlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        achievements.append(Achievement.RedPlane50.gkAchievement)
        achievements.append(Achievement.RedPlane100.gkAchievement)
        achievements.append(Achievement.RedPlane150.gkAchievement)

        return achievements
    }

    fileprivate func bluePlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        achievements.append(Achievement.BluePlane50.gkAchievement)
        achievements.append(Achievement.BluePlane100.gkAchievement)
        achievements.append(Achievement.BluePlane150.gkAchievement)

        return achievements
    }

    fileprivate func yellowPlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        achievements.append(Achievement.YellowPlane50.gkAchievement)
        achievements.append(Achievement.YellowPlane100.gkAchievement)
        achievements.append(Achievement.YellowPlane150.gkAchievement)

        return achievements
    }

    fileprivate func greenPlaneFlightAchievements() -> [GKAchievement] {
        var achievements: [GKAchievement] = []

        achievements.append(Achievement.GreenPlane50.gkAchievement)
        achievements.append(Achievement.GreenPlane100.gkAchievement)
        achievements.append(Achievement.GreenPlane150.gkAchievement)

        return achievements
    }

    fileprivate func planeFlightAchievements(_ planeType: PlaneType) -> [GKAchievement] {
        var achievements: [GKAchievement] = []
        
        switch planeType {
        case .Red:
            achievements.append(contentsOf: redPlaneFlightAchievements())
            
        case .Blue:
            achievements.append(contentsOf: bluePlaneFlightAchievements())
            
        case .Yellow:
            achievements.append(contentsOf: yellowPlaneFlightAchievements())

        case .Green:
            achievements.append(contentsOf: greenPlaneFlightAchievements())
        }
        
        return achievements
    }
}
