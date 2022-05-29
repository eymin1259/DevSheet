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
            .request(
                AnswerAPI.fertchAnswer(questionId: questionId)
            )
            .map { snapshot in
                let id = snapshot.documents.first!.documentID
                let data = snapshot.documents.first!.data()
                return AnswerDTO(id: id, dictionary: data).toDomain()
            }
    }
}
