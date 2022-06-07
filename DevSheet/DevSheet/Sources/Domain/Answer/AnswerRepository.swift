//
//  AnswerRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol AnswerRepository {
    func fetchAllAnswers(questionId: String) -> Single<Answer>
    func addNewAnswer(
        questionId: String, title: String, content: String, creator: String
    ) -> Single<String>
}
