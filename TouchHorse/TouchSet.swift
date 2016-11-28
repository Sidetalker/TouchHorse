//
//  TouchSet.swift
//  TouchHorse
//
//  Created by Kevin Sullivan on 11/27/16.
//  Copyright © 2016 Kevin Sullivan. All rights reserved.
//

import PromiseKit

enum TouchSetType: String {
    case taps = "taps"
}

struct TapData {
    
    var duration: Double
    var startTime: Double
    var xLocation: CGFloat
    var yLocation: CGFloat
    
    var dictionary: [String : Any] {
        return [
            "duration" : duration,
            "startTime" : startTime,
            "xLocation" : xLocation,
            "yLocation" : yLocation
        ]
    }
    
    init?(dictionary dict: [String : Any]) {
        guard
            let duration = dict["duration"] as? Double,
            let startTime = dict["startTime"] as? Double,
            let xLocation = dict["xLocation"] as? CGFloat,
            let yLocation = dict["yLocation"] as? CGFloat
        else { return nil }
        
        self.duration = duration
        self.startTime = startTime
        self.xLocation = xLocation
        self.yLocation = yLocation
    }
    
    init(duration: Double, startTime: Double, location: CGPoint, frameSize: CGSize) {
        self.duration = duration
        self.startTime = startTime
        self.xLocation = location.x / frameSize.width
        self.yLocation = location.y / frameSize.height
    }
    
}

class TouchSet {
    
    var key: String
    var type: TouchSetType
    
    var name: String?
    var startTime: Double?
    var taps: [TapData]?
    
    init(key: String, type: TouchSetType, data: [String : Any]) {
        self.key = key
        self.type = type
        
        if let tapDicts = data["taps"] as? [[String : Any]] {
            self.taps = [TapData]()
            
            for tapDict in tapDicts {
                guard let tapData = TapData(dictionary: tapDict) else { continue }
                self.taps?.append(tapData)
            }
        }
    }
    
    class func create(with taps: [TapData], named name: String, started start: Date) -> Promise<TouchSet> {
        let ref = FIRDatabase.database().reference()
        
        var data: [String : Any] = [
            "name" : name,
            "startTime" : start.timeIntervalSince1970,
            "type" : "taps"
        ]
        var tapArray = [[String : Any]]()
        
        for tap in taps {
            tapArray.append(tap.dictionary)
        }
        
        data["taps"] = tapArray
        
        return ref.child("touchSet").childByAutoId().set(data: data).then { ref in
            return TouchSet(key: ref.key, type: .taps, data: data)
        }
    }
    
}
