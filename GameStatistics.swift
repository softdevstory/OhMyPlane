//
//  GameStatistics.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 27..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import Foundation

enum GameStatistics: String {
    
    case flightCountRedPlane
    case flightCountYellowPlane
    case flightCountGreenPlane
    case flightCountBluePlane
    case goldMedalCount
    case silverMedalCount
    case bronzeMedalCount
    case flightCount
    
    func getValue() -> Int {
        return UserDefaults.standard.integer(forKey: self.rawValue)
    }
    
    fileprivate func setValue(_ value: Int) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
    
    func increaseCountByOne() {
        let value = self.getValue() + 1
        self.setValue(value)
    }
}
