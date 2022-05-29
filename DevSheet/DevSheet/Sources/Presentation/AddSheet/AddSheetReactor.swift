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
    
    // MARK: initialize
    init(
        questionUseCase: QuestionUseCase
    ) {
        self.questionUseCase = questionUseCase
    }
}
