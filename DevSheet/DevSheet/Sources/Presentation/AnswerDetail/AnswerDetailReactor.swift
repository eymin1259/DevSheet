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
        case viewDidAppear
        case addFavorite
        case removeFavorite
    }
    
    enum Mutation {
        case setLatestAnswer(Answer)
        case setAddFavoriteResult(Bool)
        case setRemoveFavoriteResult(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var category: Category
        var question: Question
        var latestAnswer: Answer?
        var addFavoriteResult: Bool?
        var removeFavoriteResult: Bool?
        var isLoading: Bool = false
    }
    
    let initialState: State
    var categoryUseCase: CategoryUseCase
    var questionUseCase: QuestionUseCase
    var answerUseCase: AnswerUseCase
    
    // MARK: initialize
    init(
        category: Category,
        question: Question,
        categoryUseCase: CategoryUseCase,
        questionUseCase: QuestionUseCase,
        answerUseCase: AnswerUseCase
    ) {
        self.initialState = .init(
            category: category,
            question: question
        )
        self.categoryUseCase = categoryUseCase
        self.questionUseCase = questionUseCase
        self.answerUseCase = answerUseCase
    }
}

extension AnswerDetailReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            guard !self.currentState.isLoading else { return .empty() }
            let questionId = self.currentState.question.id
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setAnswer = self.answerUseCase
                .fetchAllAnswers(questionId: questionId)
                .asObservable()
                .catchAndReturn(.getEmptyAnswer())
                .map { answer -> Mutation in
                    return .setLatestAnswer(answer)
                }
            return .concat([startLoading, setAnswer, endLoading])
            
        case .addFavorite:
            let category = self.currentState.category
            let question = self.currentState.question
            let setAddFavoriteResult = categoryUseCase.saveFavoriteCategory(category: category)
                .flatMap { result -> Single<Bool> in
                    if result {
                        return self.questionUseCase.saveFavoriteQuestion(question: question)
                    } else {
                        return Single<Bool>.just(false)
                    }
                }
                .asObservable()
                .map(AnswerDetailReactor.Mutation.setAddFavoriteResult)
            return setAddFavoriteResult
            
        case .removeFavorite:
            let question = self.currentState.question
            let setRemoveFavoriteResult = self.questionUseCase
                .removeFavoriteQuestion(
                    question: question
                )
                .asObservable()
                .map(AnswerDetailReactor.Mutation.setRemoveFavoriteResult)
            return setRemoveFavoriteResult
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLatestAnswer(let answer):
            newState.addFavoriteResult = nil
            newState.latestAnswer = answer
            return newState
            
        case .setAddFavoriteResult(let result):
            newState.addFavoriteResult = result
            return newState
            
        case .setRemoveFavoriteResult(let result):
            newState.removeFavoriteResult = result
            return newState
            
        case .setLoading(let loading):
            newState.addFavoriteResult = nil
            newState.isLoading = loading
            return newState
        }
    }
}
