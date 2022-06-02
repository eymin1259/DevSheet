//
//  AddSheetReactor.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import ReactorKit

final class AddSheetReactor: Reactor {

    // MARK: properties
    enum Action {
        case addSheet(Category, String, String) // Category, question, answer
    }
    
    enum Mutation {
        case setResult(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var addSheetResult: Bool?
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
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
}
