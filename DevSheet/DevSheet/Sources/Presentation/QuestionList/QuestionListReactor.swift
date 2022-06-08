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
        case tapRandomBtn
    }
    
    enum Mutation {
        case setQuestions([Question])
        case setRandomQUestion(Question?)
        case setLoading(Bool)
    }
    
    struct State {
        var questionSections: [QuestionListSection] = [.init(questionList: [])]
        var randomQuestion: Question?
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
            
        case .tapRandomBtn:
            let questionCount = self.currentState.questionSections.first?.items.count ?? 0
            let randomIdx = Int.random(in: 0..<questionCount)
            let randomQuestion = self.currentState.questionSections.first?.items[randomIdx]
            return Observable<Mutation>.just(.setRandomQUestion(randomQuestion))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setQuestions(let list):
            newState.randomQuestion = nil
            newState.questionSections = [.init(questionList: list)]
            return newState
            
        case .setRandomQUestion(let question):
            newState.randomQuestion = question
            return newState
            
        case .setLoading(let loading):
            newState.randomQuestion = nil
            newState.isLoading = loading
            return newState
        }
    }
}
