//
//  TopThreeRecords.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 4..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import Foundation

enum Rank: Int {
    case gold      = 3
    case silver    = 2
    case bronze    = 1
    case none      = 0
    
    var imageFileName: String? {
        switch self {
        case .gold:
            return "gold"
        case .silver:
            return "silver"
        case .bronze:
            return "bronze"
        case .none:
            return nil
        }
    }
}

class RecordItem: NSObject, NSCoding {
    var planeType: String
    var point: Int

    required init?(coder aDecoder: NSCoder) {
        planeType = aDecoder.decodeObject(forKey: "planeType") as! String
        point = aDecoder.decodeInteger(forKey: "point")
        
        super.init()
    }
    
    init(planeType: String, point: Int) {
        self.planeType = planeType
        self.point = point
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(planeType, forKey: "planeType")
        aCoder.encode(point, forKey: "point")
    }
}

class TopThreeRecords {
    var topThreeRecords: [RecordItem] = []
    
    init() {
        load()
    }
    
    fileprivate func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        return (paths[0] as NSString).appendingPathComponent(GameSetting.TopThreeRecordFileName)
    }
    
    fileprivate func loadForIOS() {
        let path = dataFilePath()
        
        if FileManager.default.fileExists(atPath: path) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                topThreeRecords = unarchiver.decodeObject(forKey: "TopThreeRecords") as! [RecordItem]
                unarchiver.finishDecoding()
                
                topThreeRecords.sort() {
                    $0.point > $1.point
                }
            }
        } else {
            // initial records
            for point in [30, 20, 10] {
                let item = RecordItem(planeType: PlaneType.Red.rawValue, point: point)
                topThreeRecords.append(item)
            }
            
            topThreeRecords.sort() {
                $0.point > $1.point
            }
            saveForIOS()
        }
    }
    
    fileprivate func saveForIOS() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(topThreeRecords, forKey: "TopThreeRecords")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    fileprivate func loadForTvOS() {
        let userDefault = UserDefaults.standard
        let keyStrings = ["goldMedal", "silverMedal", "bronzeMedal"]
        let defaultPoints = [30, 20, 10]
        
        if let _ = userDefault.string(forKey: "goldMedalPlane") {
            for (index, keyString) in keyStrings.enumerated() {
                if let planeType = userDefault.string(forKey: "\(keyString)Plane") {
                    let point = userDefault.integer(forKey: "\(keyString)Point")
                    let item = RecordItem(planeType: planeType, point: point)
                    
                    topThreeRecords.append(item)
                } else {
                    let item = RecordItem(planeType: PlaneType.Red.rawValue, point: defaultPoints[index])
                    
                    topThreeRecords.append(item)
                }
            }
            
            topThreeRecords.sort() {
                $0.point > $1.point
            }
        } else {
            // initial records
            for point in defaultPoints {
                let item = RecordItem(planeType: PlaneType.Red.rawValue, point: point)
                topThreeRecords.append(item)
            }
            
            topThreeRecords.sort() {
                $0.point > $1.point
            }
            saveForTvOS()
        }
    }
    
    fileprivate func saveForTvOS() {
        let userDefault = UserDefaults.standard
        let keyStrings = ["goldMedal", "silverMedal", "bronzeMedal"]

        for (index, keyString) in keyStrings.enumerated() {
            userDefault.set(topThreeRecords[index].planeType, forKey: "\(keyString)Plane")
            userDefault.set(topThreeRecords[index].point, forKey: "\(keyString)Point")
        }
    }
    
    fileprivate func load() {
        #if os(iOS)
            loadForIOS()
        #elseif os(tvOS)
            loadForTvOS()
        #endif
    }
    
    fileprivate func save() {
        #if os(iOS)
            saveForIOS()
        #elseif os(tvOS)
            saveForTvOS()
        #endif
    }

    func getRankOfPoint(_ point: Int) -> Rank {
        var result: Rank = .gold
        
        for record in topThreeRecords {
            if record.point >= point {
                result = Rank(rawValue: result.rawValue - 1)!
            }
        }
        
        return result
    }
    
    func checkAndReplacePoint(_ planeType: String, point: Int) {
        let item = RecordItem(planeType: planeType, point: point)
        topThreeRecords.append(item)
        topThreeRecords.sort() {
            $0.point > $1.point
        }
        
        if topThreeRecords.count > 3 {
            topThreeRecords.removeLast()
        }
        
        save()
    }
    
}
