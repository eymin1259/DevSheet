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
    var localDBService: LocalDBService
    
    // MARK: initialize
    init(
        firebaseService: FirebaseService,
        localDBService: LocalDBService
    ) {
        self.firebaseService = firebaseService
        self.localDBService = localDBService
    }
    
    // MARK: methods
    func fetchQuestions(categoryId: String) -> Single<[Question]> {
        return firebaseService
            .get(
                QuestionAPI.getQuestions(categoryId: categoryId)
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
    
    func addNewQuestion(categoryId: String, title: String) -> Single<String> {
        return firebaseService
            .post(
                QuestionAPI.addNewQuestion(categoryId: categoryId, title: title)
            )
            .map { $0.documentID }
    }
    
    func fetchFavoriteQuestions() -> [Question] {
        let results = localDBService.fetch(object: QuestionDTO.self)
        var ret: [Question] = .init()
        results.forEach { dto in
            ret.append(dto.toDomain())
        }
        return ret
    }
    
    func saveFavoriteQuestion(question: Question) -> Single<Bool> {
        let questionDTO = QuestionDTO(
            id: question.id,
            dictionary: [
                "title": question.title,
                "categoryId": question.categoryId,
                "timeStamp": question.createdAt,
                "deleted": question.deleted
            ])
        return localDBService.write(object: questionDTO)
    }
    
}
