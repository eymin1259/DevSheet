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
    
    func task() -> Single<Query> {
        switch self {
        case .fetchQuestions(let categoryId):
            return Single<Query>.create { single in
                single(.success(
                    collection
                        .whereField("categoryId", isEqualTo: categoryId)
                        .whereField("deleted", isEqualTo: false)
                ))
                return Disposables.create()
            }
        }
    }
}
