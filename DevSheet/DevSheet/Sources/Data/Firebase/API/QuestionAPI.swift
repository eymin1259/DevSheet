//
//  QuestionAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase

enum QuestionAPI {
    case getQuestions(categoryId: String)
    case addNewQuestion(categoryId: String, title: String)
}

extension QuestionAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("questions")
    }
    
    func get() -> Query? {
        switch self {
        case .getQuestions(let categoryId):
            return collection
                .whereField("categoryId", isEqualTo: categoryId)
                .whereField("deleted", isEqualTo: false)
        default:
            return nil
        }
    }
    
    func post(completion: @escaping (Error?, DocumentReference?) -> Void) {
        switch self {
        case .addNewQuestion(let categoryId, let title):
            var ref: DocumentReference?
            ref = collection.addDocument(data: [
                "categoryId": categoryId,
                "title": title,
                "deleted": false,
                "timeStamp": Timestamp(date: Date())
            ]) { err in
                completion(err, ref)
            }
        default:
            completion(nil, nil)
        }
    }
}
