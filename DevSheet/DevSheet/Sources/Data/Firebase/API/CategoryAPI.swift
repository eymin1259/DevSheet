//
//  CategoryAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import Firebase

enum CategoryAPI {
    case fetchCategories(group: Int)
}

extension CategoryAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("categories")
    }
    
    func task() -> Query {
        switch self {
        case .fetchCategories(let group):
            return collection
                .whereField("group", isEqualTo: group)
                .order(by: "order", descending: false)
        }
    }
}
