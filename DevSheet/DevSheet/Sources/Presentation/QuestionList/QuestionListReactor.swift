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
        case viewDidAppear
        case tapRandomBtn
    }
    
    enum Mutation {
        case setQuestions([Question])
        case setRandomQUestion(Question?)
        case setLoading(Bool)
    }
    
    struct State {
        var categoryGroup: MainTab
        var category: Category
        var questionSections: [QuestionListSection] = [.init(questionList: [])]
        var randomQuestion: Question?
        var isLoading: Bool = false
    }
    
    let initialState: State
    var questionUseCase: QuestionUseCase
    
    // MARK: initialize
    init(
        categoryGroup: MainTab,
        category: Category,
        questionUseCase: QuestionUseCase
    ) {
        self.initialState = .init(
            categoryGroup: categoryGroup,
            category: category
        )
        self.questionUseCase = questionUseCase
    }
}

extension QuestionListReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            guard !self.currentState.isLoading else { return .empty() }
            let categoryGroup = self.currentState.categoryGroup
            let categoryId = self.currentState.category.id
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
            if let questionCount = self.currentState.questionSections.first?.items.count,
               questionCount > 0 {
                let randomIdx = Int.random(in: 0..<questionCount)
                let randomQuestion = self.currentState.questionSections.first?.items[randomIdx]
                return Observable<Mutation>.just(.setRandomQUestion(randomQuestion))
            } else {
                return .empty()
            }
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
