//
//  VersionAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import Firebase

enum VersionAPI {
    case getVersionCheck
}

extension VersionAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("versions")
    }
    
    func task() -> Query {
        switch self {
        case .getVersionCheck:
            return collection
                .order(by: "timeStamp", descending: true)
                .limit(to: 1)
        }
    }
}
