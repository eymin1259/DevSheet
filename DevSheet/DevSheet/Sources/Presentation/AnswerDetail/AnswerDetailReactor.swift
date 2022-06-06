//
//  AnswerDetailReactor.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import ReactorKit

final class AnswerDetailReactor: Reactor {

    // MARK: properties
    enum Action {
        case viewDidAppear(String) // questionId
        case addFavorite(Category, Question)
    }
    
    enum Mutation {
        case setLatestAnswer(Answer)
        case setAddFavoriteResult(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var latestAnswer: Answer?
        var addFavoriteResult: Bool?
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
    var answerUseCase: AnswerUseCase
    
    // MARK: initialize
    init(answerUseCase: AnswerUseCase) {
        self.answerUseCase = answerUseCase
    }
}

extension AnswerDetailReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear(let questionId):
            guard !self.currentState.isLoading else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setAnswer = self.answerUseCase
                .fetchAnswer(questionId: questionId)
                .asObservable()
                .catchAndReturn(.getEmptyAnswer())
                .map { answer -> Mutation in
                    return .setLatestAnswer(answer)
                }
            return .concat([startLoading, setAnswer, endLoading])
            
        case .addFavorite(let category, let question):
            print("debubug : reactor addFavorite -> \(category.id), \(question.id)")
            return .empty()
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLatestAnswer(let answer):
            newState.latestAnswer = answer
            return newState
            
        case .setAddFavoriteResult(let result):
            newState.addFavoriteResult = result
            return newState
            
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
