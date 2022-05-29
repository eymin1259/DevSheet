//
//  QuestionListReactor.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import ReactorKit

final class QuestionListReactor: Reactor {

    // MARK: properties
    enum Action {
        case viewDidAppear(String) // categoryId: String
        case refresh
    }
    
    enum Mutation {
        case setCategories([Category])
        case setLoading(Bool)
    }
    
    struct State {
        var questionSections: [QuestionListSection] = [.init(questionList: [])]
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
    var questionUseCase: QuestionUseCase
    
    // MARK: initialize
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
}

extension QuestionListReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        
        return .empty()
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
 
        return newState
    }
}
