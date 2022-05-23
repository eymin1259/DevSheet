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
    
    func task() -> Single<QuerySnapshot> {
        switch self {
        case .fetchCategories(let group):
            return Single<QuerySnapshot>.create { single in
                collection
                    .whereField("group", isEqualTo: group)
                    .order(by: "order", descending: false)
                    .getDocuments { snapshot, err in
                        if let err = err {
                            single(.failure(err))
                        }
                        if let  snapshot = snapshot,
                           snapshot.isEmpty == false {
                            single(.success(snapshot))
                        } else {
                            single(.failure(FirebaseError.noData))
                        }
                    }
                return Disposables.create()
            }
        }
    }
}
