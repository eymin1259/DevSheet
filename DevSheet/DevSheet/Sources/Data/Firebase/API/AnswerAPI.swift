//
//  AnswerAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase
import RxSwift

enum AnswerAPI {
    case fertchAnswer(questionId: String)
}

extension AnswerAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("answers")
    }
    
    func task() -> Single<Query> {
        switch self {
        case .fertchAnswer(let questionId):
            return Single<Query>.create { single in
                single(.success(
                    collection
                        .whereField("questionId", isEqualTo: questionId)
                        .whereField("deleted", isEqualTo: false)
                        .order(by: "timeStamp", descending: true)
                        .limit(to: 1)
                ))
                return Disposables.create()
            }
        }
    }
}
