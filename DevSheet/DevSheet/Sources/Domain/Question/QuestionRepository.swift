//
//  QuestionRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift

protocol QuestionRepository {
    func fetchQuestions(categoryId: String) -> Single<[Question]>
}
