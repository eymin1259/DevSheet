//
//  QuestionAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase
import RxSwift

enum QuestionAPI {
    case fetchQuestions(categoryId: String)
}

extension QuestionAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("questions")
    }
    
    func task() -> Single<QuerySnapshot> {
        switch self {
        case .fetchQuestions(let categoryId):
            return Single<QuerySnapshot>.create { single in
                collection
                    .whereField("categoryId", isEqualTo: categoryId)
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
