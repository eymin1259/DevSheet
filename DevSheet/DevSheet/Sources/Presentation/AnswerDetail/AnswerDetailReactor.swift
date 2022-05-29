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
        case viewDidLoad(String) // questionId
    }
    
    enum Mutation {
        case setLatestAnswer(Answer)
        case setLoading(Bool)
    }
    
    struct State {
        var latestAnswer: Answer = .getEmptyAnswer()
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
        case .viewDidLoad(let questionId):
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
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLatestAnswer(let answer):
            newState.latestAnswer = answer
            return newState
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
