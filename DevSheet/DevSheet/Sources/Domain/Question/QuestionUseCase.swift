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
    func addNewQuestion(categoryId: String, title: String) -> Single<String>
    func saveFavoriteQuestion(question: Question) -> Single<Bool>
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
    
    func addNewQuestion(categoryId: String, title: String) -> Single<String> {
        return questionRepository.addNewQuestion(categoryId: categoryId, title: title)
    }
    
    func saveFavoriteQuestion(question: Question) -> Single<Bool> {
        let favoriteQuestions = questionRepository.fetchFavoriteQuestions().filter { favQuestion in
            favQuestion.id == question.id
        }
        if favoriteQuestions.isEmpty {
            return questionRepository.saveFavoriteQuestion(question: question)
        } else {
            return Single<Bool>.just(true)
        }
    }
}
