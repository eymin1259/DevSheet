//
//  CategoryAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import Firebase
import RxSwift

enum CategoryAPI {
    case fetchCategories(group: Int)
}

extension CategoryAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("categories")
    }
    
    func task() -> Single<Query> {
        switch self {
        case .fetchCategories(let group):
            return Single<Query>.create { single in
                single(.success(
                    collection
                        .whereField("group", isEqualTo: group)
                        .order(by: "order", descending: false)
                ))
                
                return Disposables.create()
            }
        }
    }
}
