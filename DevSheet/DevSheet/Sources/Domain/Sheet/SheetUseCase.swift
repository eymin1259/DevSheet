//
//  SheetUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 6/4/22.
//

import Foundation
import RxSwift

protocol SheetUseCase {
    func addNewSheet(categoryId: String, questionText: String?, answerText: String?) -> Single<Bool>
    func updateSheet(question: Question, questionText: String?, answerText: String?) -> Single<Bool>
}

final class SheetUseCaseImpl: SheetUseCase {
    // MARK: properties
    var questionUseCase: QuestionUseCase
    var answerUseCase: AnswerUseCase
    
    // MARK: initialize
    init(
        questionUseCase: QuestionUseCase,
        answerUseCase: AnswerUseCase
    ) {
        self.questionUseCase = questionUseCase
        self.answerUseCase = answerUseCase
    }
    
    // MARK: methods
    func addNewSheet(
        categoryId: String,
        questionText: String?,
        answerText: String?
    ) -> Single<Bool> {
        guard let questionText = questionText else { return .error(SheetError.emptyQuestion) }
        guard !questionText.isEmpty else { return .error(SheetError.emptyQuestion) }
        guard let answerText = answerText else { return .error(SheetError.emptyAnswer) }
        guard !answerText.isEmpty else { return .error(SheetError.emptyAnswer) }
        return questionUseCase
            .addNewQuestion(
                categoryId: categoryId,
                title: questionText
            )
            .flatMap { questionId in
                self.answerUseCase.addNewAnswer(questionId: questionId, title: questionText, content: answerText)
            }
            .map { _ in true }
    }
    
    func updateSheet(question: Question, questionText: String?, answerText: String?) -> Single<Bool> {
        guard let questionText = questionText else { return .error(SheetError.emptyQuestion) }
        guard !questionText.isEmpty else { return .error(SheetError.emptyQuestion) }
        guard let answerText = answerText else { return .error(SheetError.emptyAnswer) }
        guard !answerText.isEmpty else { return .error(SheetError.emptyAnswer) }
        return questionUseCase
            .updateQuestion(questionId: question.id, field: [
                "title": questionText
            ])
            .flatMap { _ in
                self.answerUseCase
                    .addNewAnswer(
                        questionId: question.id, title: questionText, content: answerText)
            }
            .map { _ in true }
    }
}
