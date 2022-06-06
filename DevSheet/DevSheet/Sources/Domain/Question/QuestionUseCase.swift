//
//  QuestionUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol QuestionUseCase {
    func fetchQuestions(categoryGroup: MainTab, categoryId: String) -> Single<[Question]>
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
    func fetchQuestions(categoryGroup: MainTab, categoryId: String) -> Single<[Question]> {
        return questionRepository.fetchQuestions(
            categoryGroup: categoryGroup,
            categoryId: categoryId
        )
    }
    
    func addNewQuestion(categoryId: String, title: String) -> Single<String> {
        return questionRepository.addNewQuestion(categoryId: categoryId, title: title)
    }
    
    func saveFavoriteQuestion(question: Question) -> Single<Bool> {        
        return questionRepository.fetchAllFavoriteQuestions(categoryId: nil)
            .flatMap { [unowned self] questionList -> Single<Bool> in
                let favoriteQuestions = questionList.filter { favQuestion in
                    favQuestion.id == question.id
                }
                if favoriteQuestions.isEmpty {
                    return questionRepository.saveFavoriteQuestion(question: question)
                } else {
                    return Single<Bool>.just(true)
                }
            }
    }
}
