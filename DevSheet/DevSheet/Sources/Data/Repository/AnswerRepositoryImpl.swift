//
//  AnswerRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift
import Firebase

final class AnswerRepositoryImpl: AnswerRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    
    // MARK: initialize
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: methods
    func fetchAnswer(questionId: String) -> Single<Answer> {
        return firebaseService
            .get(
                AnswerAPI.gethAnswer(questionId: questionId)
            )
            .map { snapshot in
                let id = snapshot.documents.first!.documentID
                let data = snapshot.documents.first!.data()
                return AnswerDTO(id: id, dictionary: data).toDomain()
            }
    }
    
    func addNewAnswer(
        questionId: String, title: String, content: String, creator: String
    ) -> Single<String> {
        return firebaseService
            .post(
                AnswerAPI.addNewAnswer(
                    questionId: questionId,
                    title: title,
                    content: content,
                    creator: creator
                )
            )
            .map { $0.documentID }
    }
}
