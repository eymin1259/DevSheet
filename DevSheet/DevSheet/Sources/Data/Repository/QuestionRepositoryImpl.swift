//
//  QuestionRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift
import Firebase

final class QuestionRepositoryImpl: QuestionRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    
    // MARK: initialize
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: methods
    func fetchQuestions(categoryId: String) -> Single<[Question]> {
        return firebaseService
            .request(
                QuestionAPI.fetchQuestions(categoryId: categoryId)
            )
            .map { snapshot in
                var ret = [Question]()
                for doc in snapshot.documents {
                    let id = doc.documentID
                    let data = doc.data()
                    let question = QuestionDTO(id: id, dictionary: data).toDomain()
                    ret.append(question)
                }
                return ret
            }
    }
}
