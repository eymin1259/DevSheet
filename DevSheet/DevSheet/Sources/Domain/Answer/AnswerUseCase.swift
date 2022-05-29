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
}
