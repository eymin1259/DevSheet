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
    func addNewSheet(
        categoryId: String,
        questionText: String?,
        answerText: String?
    ) -> Single<Bool> {
        guard let questionText = questionText else { return .error(SheetError.emptyQuestion) }
        guard !questionText.isEmpty else { return .error(SheetError.emptyQuestion) }
        guard let answerText = answerText else { return .error(SheetError.emptyAnswer) }
        guard !answerText.isEmpty else { return .error(SheetError.emptyAnswer) }
        let uuid  = UIDevice.current.identifierForVendor?.uuidString ?? "unknown uuid "
        
        return questionRepository
            .addNewQuestion(
                categoryId: categoryId,
                title: questionText
            )
            .flatMap { questionId in
                self.answerRepository.addNewAnswer(questionId: questionId, title: questionText, content: answerText, creator: uuid)
            }
            .map { _ in true }
    }
    
    func updateSheet(question: Question, questionText: String?, answerText: String?) -> Single<Bool> {
        guard let questionText = questionText else { return .error(SheetError.emptyQuestion) }
        guard !questionText.isEmpty else { return .error(SheetError.emptyQuestion) }
        guard let answerText = answerText else { return .error(SheetError.emptyAnswer) }
        guard !answerText.isEmpty else { return .error(SheetError.emptyAnswer) }
        let uuid  = UIDevice.current.identifierForVendor?.uuidString ?? "unknown uuid "
        
        // question update
        return questionRepository
            .updateQuestion(questionId: question.id, field: [
                "title": questionText
            ])
            .flatMap { _ in
                self.answerRepository
                    .addNewAnswer(
                        questionId: question.id, title: questionText, content: answerText, creator: uuid
                    )
            }
            .map { _ in true }
    }
}
