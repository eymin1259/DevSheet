//
//  QuestionRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol QuestionRepository {
    func fetchAllQuestions(categoryId: String) -> Single<[Question]>
    func fetchQuestions(categoryId: String, questionIdList: [String]) -> Single<[Question]>
    func addNewQuestion(categoryId: String, title: String) -> Single<String>
    func updateQuestion(questionId: String, field: [String: Any]) -> Single<Bool>
    func fetchAllFavoriteQuestions(categoryId: String?) -> Single<[Question]>
    func saveFavoriteQuestion(question: Question) -> Single<Bool>
    func removeFavoriteQuestion(question: Question) -> Single<Bool>
}
