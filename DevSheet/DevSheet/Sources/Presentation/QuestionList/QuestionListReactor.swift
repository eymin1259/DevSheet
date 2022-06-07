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
        case viewDidAppear(MainTab, String) // categoryId: String
    }
    
    enum Mutation {
        case setQuestions([Question])
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
        switch action {
        case .viewDidAppear(let categoryGroup, let categoryId):
            guard !self.currentState.isLoading else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            var fetchQuestions: Single<[Question]>
            if categoryGroup == .favorite {
                fetchQuestions = questionUseCase.fetchAllFavoriteQuestions(categoryId: categoryId)
            } else {
                fetchQuestions = questionUseCase.fetchAllQuestions(categoryId: categoryId)
            }
            let setQuestions = fetchQuestions
                .asObservable()
                .catchAndReturn([])
                .map { questionList -> Mutation in
                    return .setQuestions(questionList)
                }
            return .concat([startLoading, setQuestions, endLoading])
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setQuestions(let list):
            newState.questionSections = [.init(questionList: list)]
            return newState
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
