//
//  CategoryAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import Firebase

enum CategoryAPI {
    case getCategories(groupId: Int)
}

extension CategoryAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("categories")
    }
    
    func get() -> Query? {
        switch self {
        case .getCategories(let groupId):
            return collection
                .whereField("groupId", isEqualTo: groupId)
                .order(by: "orderNumber", descending: false)
        }
    }
    
    func post(completion: @escaping (Error?, DocumentReference?) -> Void) {
        switch self {
        default:
            completion(nil, nil)
        }
    }
}
