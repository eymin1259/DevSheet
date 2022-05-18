//
//  Entity.Version.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import Firebase

extension Entity {
    struct Version {
        var id: String
        var version: String
        var timeStamp: Timestamp
        var shouldUpdate: Bool
        
        init(id: String, dictionary: [String: Any]) {
            self.id = id
            self.version = dictionary["version"] as? String ?? "0.0"
            self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
            self.shouldUpdate = dictionary["shouldUpdate"] as? Bool ?? false
        }
    }
}
