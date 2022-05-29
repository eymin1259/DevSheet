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
    
    func task() -> Single<QuerySnapshot> {
        switch self {
        case .fertchAnswer(let questionId):
            return Single<QuerySnapshot>.create { single in
                collection
                    .whereField("questionId", isEqualTo: questionId)
                    .whereField("deleted", isEqualTo: false)
                    .order(by: "timeStamp", descending: true)
                    .limit(to: 1)
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
