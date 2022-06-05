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
    case addNewAnswer(questionId: String, title: String, content:String, creator: String)
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
        default:
            return nil
        }
    }
    
    func post(completion: @escaping (Error?, DocumentReference?) -> Void) {
        switch self {
        case .addNewAnswer(let questionId, let title, let content, let creator):
            var ref: DocumentReference?
            ref = collection.addDocument(data: [
                "questionId": questionId,
                "questionTitle": title,
                "answerContent": content,
                "version": 1,
                "createdBy": creator,
                "timeStamp": Timestamp(date: Date()),
                "deleted": false
            ]) { err in
                completion(err, ref)
            }
        default:
            completion(nil, nil)
        }
    }
}
