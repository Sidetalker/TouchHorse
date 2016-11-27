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

class TouchSet {
    
    var type: TouchSetType?
    var taps: [TouchMetadata]?
    
    init(key: String, dictionary: [String : Any]) {
        
    }
    
    class func create(with taps: [TouchMetadata], named name: String, started start: Date) -> Promise<TouchSet> {
        let ref = FIRDatabase.database().reference()
        
        var data: [String : Any] = [
            "name" : name,
            "startTime" : start.timeIntervalSince1970,
            "type" : "taps"
        ]
        var tapArray = [[String : Any]]()
        
        for tap in taps {
            guard let duration = tap.duration else { continue }
            
            let tapData: [String : Any] = [
                "duration" : duration,
                "startTime" : tap.startTime.timeIntervalSince1970,
                "xLocation" : tap.startLocation.x,
                "yLocation" : tap.startLocation.y
            ]
            
            tapArray.append(tapData)
        }
        
        data["taps"] = tapArray
        
        return ref.child("touchSet").childByAutoId().set(data: data).then { ref in
            return TouchSet(key: ref.key, dictionary: data)
        }
    }
    
}
