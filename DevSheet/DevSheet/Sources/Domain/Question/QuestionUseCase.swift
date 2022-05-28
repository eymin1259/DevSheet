//
//  QuestionUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol QuestionUseCase {
    func fetchQuestions(categoryId: String) -> Single<[Question]>
}

final class QuestionUseCaseImpl: QuestionUseCase {
    
    // MARK: properties
    var questionRepository: QuestionRepository
    
    // MARK: initialize
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    // MARK: methods
    func fetchQuestions(categoryId: String) -> Single<[Question]> {
        return questionRepository.fetchQuestions(categoryId: categoryId)
    }
}
