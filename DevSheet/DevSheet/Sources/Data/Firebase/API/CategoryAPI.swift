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
    case fetchCategories
}

extension CategoryAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("categories")
    }
    
    func task() -> Single<QuerySnapshot> {
        switch self {
        case .fetchCategories:
            return Single<QuerySnapshot>.create { single in
    
                return Disposables.create()
            }
        }
    }
}
