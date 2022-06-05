//
//  CategoryAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import Firebase

enum CategoryAPI {
    case getCategories(group: Int)
}

extension CategoryAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("categories")
    }
    
    func get() -> Query? {
        switch self {
        case .getCategories(let group):
            return collection
                .whereField("group", isEqualTo: group)
                .order(by: "order", descending: false)
        }
    }
    
    func post(completion: @escaping (Error?, DocumentReference?) -> Void) {
        switch self {
        default:
            completion(nil, nil)
        }
    }
}
