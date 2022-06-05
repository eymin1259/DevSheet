//
//  SheetUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 6/4/22.
//

import Foundation
import RxSwift

protocol SheetUseCase {
    func addNewSheet()
    func updateSheet()
}

final class SheetUseCaseImpl: SheetUseCase {
    // MARK: properties
    var questionRepository: QuestionRepository
    var answerRepository: AnswerRepository
    
    // MARK: initialize
    init(
        questionRepository: QuestionRepository,
        answerRepository: AnswerRepository
    ) {
        self.questionRepository = questionRepository
        self.answerRepository = answerRepository
    }
    
    // MARK: methods
    func addNewSheet() {
        //
    }
    
    func updateSheet() {
        //
    }
}
