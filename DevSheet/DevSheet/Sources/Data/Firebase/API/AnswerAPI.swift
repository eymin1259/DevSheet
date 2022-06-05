//
//  AnswerAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase

enum AnswerAPI {
    case gethAnswer(questionId: String)
}

extension AnswerAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("answers")
    }
    
    func get() -> Query? {
        switch self {
        case .gethAnswer(let questionId):
            return collection
                .whereField("questionId", isEqualTo: questionId)
                .whereField("deleted", isEqualTo: false)
                .order(by: "version", descending: true)
                .limit(to: 1)
        }
    }
    
    func post(completion: @escaping (Error?, DocumentReference?) -> Void) {
        switch self {
        default:
            completion(nil, nil)
        }
    }
}
