//
//  TopThreeRecords.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 4..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import Foundation

enum Rank: Int {
    case First     = 3
    case Second    = 2
    case Third     = 1
    case None      = 0
    
    var imageFileName: String? {
        switch self {
        case .First:
            return "gold"
        case .Second:
            return "silver"
        case .Third:
            return "bronze"
        case .None:
            return nil
        }
    }
}

class RecordItem: NSObject, NSCoding {
    var planeType: String
    var point: Int

    required init?(coder aDecoder: NSCoder) {
        planeType = aDecoder.decodeObjectForKey("planeType") as! String
        point = aDecoder.decodeIntegerForKey("point")
        
        super.init()
    }
    
    init(planeType: String, point: Int) {
        self.planeType = planeType
        self.point = point
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(planeType, forKey: "planeType")
        aCoder.encodeInteger(point, forKey: "point")
    }
}

class TopThreeRecords {
    var topThreeRecords: [RecordItem] = []
    
    init() {
        load()
    }
    
    private func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return (paths[0] as NSString).stringByAppendingPathComponent(GameSetting.TopThreeRecordFileName)
    }
    
    private func loadForIOS() {
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                topThreeRecords = unarchiver.decodeObjectForKey("TopThreeRecords") as! [RecordItem]
                unarchiver.finishDecoding()
                
                topThreeRecords.sortInPlace() {
                    $0.point > $1.point
                }
            }
        } else {
            // initial records
            for point in [30, 20, 10] {
                let item = RecordItem(planeType: PlaneType.Red.rawValue, point: point)
                topThreeRecords.append(item)
            }
            
            topThreeRecords.sortInPlace() {
                $0.point > $1.point
            }
            saveForIOS()
        }
    }
    
    private func saveForIOS() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(topThreeRecords, forKey: "TopThreeRecords")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    private func loadForTvOS() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let keyStrings = ["goldMedal", "silverMedal", "bronzeMedal"]
        let defaultPoints = [30, 20, 10]
        
        if let _ = userDefault.stringForKey("goldMedalPlane") {
            for (index, keyString) in keyStrings.enumerate() {
                if let planeType = userDefault.stringForKey("\(keyString)Plane") {
                    let point = userDefault.integerForKey("\(keyString)Point")
                    let item = RecordItem(planeType: planeType, point: point)
                    
                    topThreeRecords.append(item)
                } else {
                    let item = RecordItem(planeType: PlaneType.Red.rawValue, point: defaultPoints[index])
                    
                    topThreeRecords.append(item)
                }
            }
            
            topThreeRecords.sortInPlace() {
                $0.point > $1.point
            }
        } else {
            // initial records
            for point in defaultPoints {
                let item = RecordItem(planeType: PlaneType.Red.rawValue, point: point)
                topThreeRecords.append(item)
            }
            
            topThreeRecords.sortInPlace() {
                $0.point > $1.point
            }
            saveForTvOS()
        }
    }
    
    private func saveForTvOS() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let keyStrings = ["goldMedal", "silverMedal", "bronzeMedal"]

        for (index, keyString) in keyStrings.enumerate() {
            userDefault.setObject(topThreeRecords[index].planeType, forKey: "\(keyString)Plane")
            userDefault.setInteger(topThreeRecords[index].point, forKey: "\(keyString)Point")
        }
    }
    
    private func load() {
        #if os(iOS)
            loadForIOS()
        #elseif os(tvOS)
            loadForTvOS()
        #endif
    }
    
    private func save() {
        #if os(iOS)
            saveForIOS()
        #elseif os(tvOS)
            saveForTvOS()
        #endif
    }

    func getRankOfPoint(point: Int) -> Rank {
        var result: Rank = .First
        
        for record in topThreeRecords {
            if record.point >= point {
                result = Rank(rawValue: result.rawValue - 1)!
            }
        }
        
        return result
    }
    
    func checkAndReplacePoint(planeType: String, point: Int) {
        let item = RecordItem(planeType: planeType, point: point)
        topThreeRecords.append(item)
        topThreeRecords.sortInPlace() {
            $0.point > $1.point
        }
        
        if topThreeRecords.count > 3 {
            topThreeRecords.removeLast()
        }
        
        save()
    }
    
}