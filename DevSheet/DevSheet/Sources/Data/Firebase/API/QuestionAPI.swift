//
//  QuestionAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase

enum QuestionAPI {
    case getAllQuestions(categoryId: String)
    case addNewQuestion(categoryId: String, title: String)
    case updateQuestion(questionId: String, field: [String: Any])
}

extension QuestionAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("questions")
    }
    
    func get() -> Query? {
        switch self {
        case .getAllQuestions(let categoryId):
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
            
        case .updateQuestion(let questionId, let field):
            let ref = collection.document(questionId)
            ref.updateData(field) { err in
                completion(err, ref)
            }
            
        default:
            completion(nil, nil)
        }
    }
}
