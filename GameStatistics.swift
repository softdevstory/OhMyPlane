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
        return NSUserDefaults.standardUserDefaults().integerForKey(self.rawValue)
    }
    
    private func setValue(value: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: self.rawValue)
        print("\(self.rawValue) value: \(value)")
    }
    
    func increaseCountByOne() {
        let value = self.getValue() + 1
        self.setValue(value)
    }
}