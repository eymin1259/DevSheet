//
//  QuestionUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol QuestionUseCase {
    func fetchAllQuestions(categoryId: String) -> Single<[Question]>
    func fetchAllFavoriteQuestions(categoryId: String)  -> Single<[Question]>
    func addNewQuestion(categoryId: String, title: String) -> Single<String>
    func updateQuestion(questionId: String, field: [String: Any]) -> Single<Bool>
    func saveFavoriteQuestion(question: Question) -> Single<Bool>
    func removeFavoriteQuestion(question: Question) -> Single<Bool>
}

final class QuestionUseCaseImpl: QuestionUseCase {
    
    // MARK: properties
    var questionRepository: QuestionRepository
    
    // MARK: initialize
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    // MARK: methods
    func fetchAllQuestions(categoryId: String) -> Single<[Question]> {
        return questionRepository.fetchAllQuestions(
            categoryId: categoryId
        )
    }
    
    func fetchAllFavoriteQuestions(categoryId: String) -> Single<[Question]> {
        return questionRepository.fetchAllFavoriteQuestions(categoryId: categoryId)
            .flatMap { [unowned self] favQuestions -> Single<[Question]> in
                let favQuestionIdList = favQuestions.map { favQuestion -> String in
                    return favQuestion.id
                }
                return questionRepository.fetchQuestions(
                    categoryId: categoryId,
                    questionIdList: favQuestionIdList
                )
            }
    }
    
    func addNewQuestion(categoryId: String, title: String) -> Single<String> {
        return questionRepository.addNewQuestion(categoryId: categoryId, title: title)
    }
    
    func updateQuestion(questionId: String, field: [String: Any]) -> Single<Bool> {
        return questionRepository.updateQuestion(questionId: questionId, field: field)
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
    
    func removeFavoriteQuestion(question: Question) -> Single<Bool> {
        return questionRepository.removeFavoriteQuestion(question: question)
    }
}
