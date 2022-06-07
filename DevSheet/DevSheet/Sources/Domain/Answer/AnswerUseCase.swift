//
//  AnswerUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol AnswerUseCase {
    func fetchAnswer(questionId: String) -> Single<Answer>
    func addNewAnswer(
        questionId: String, title: String, content: String
    ) -> Single<String>
}

final class AnswerUseCaseImpl: AnswerUseCase {
    
    // MARK: properties
    var answerRepository: AnswerRepository
    
    // MARK: initialize
    init(answerRepository: AnswerRepository) {
        self.answerRepository = answerRepository
    }
    
    // MARK: methods
    func fetchAnswer(questionId: String) -> Single<Answer> {
        return answerRepository.fetchAnswer(questionId: questionId)
    }
    
    func addNewAnswer(questionId: String, title: String, content: String) -> Single<String> {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "unknown uuid"
        return answerRepository.addNewAnswer(
            questionId: questionId,
            title: title,
            content: content,
            creator: uuid
        )
    }
}
