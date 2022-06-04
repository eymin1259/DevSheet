//
//  EditSheetReactor.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import ReactorKit

final class EditSheetReactor: Reactor {

    // MARK: properties
    enum Action {
        case viewDidLoad(Category, EditMode, String, String) // questionStr, answerStr
        case inputText(String, String) // question, answer
        case tapSaveBtn(Category, String, String) // Category, question, answer
    }
    
    enum Mutation {
        case setCategory(Category)
        case setEditMode(EditMode)
        case setQuestion(String)
        case setAnswer(String)
        case setSaveResult(Bool, String?)
        case setLoading(Bool)
    }
    
    struct State {
        var category: Category?
        var editMode: EditMode?
        var question: String?
        var answer: String?
        var saveResult: (Bool, String?)?
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

extension EditSheetReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let category, let mode, let question, let answer):
            let setCategory = Observable<Mutation>.just(.setCategory(category))
            let setEditMode = Observable<Mutation>.just(.setEditMode(mode))
            let setQuestion =  Observable<Mutation>.just(.setQuestion(question))
            let setAnswer = Observable<Mutation>.just(.setAnswer(answer))
            return .concat([setCategory, setEditMode, setQuestion, setAnswer])
        case .inputText(let question, let answer):
            let setQuestion = Observable<Mutation>.just(.setQuestion(question))
            let setAnswer = Observable<Mutation>.just(.setAnswer(answer))
            return .concat([setQuestion, setAnswer])
        case .tapSaveBtn(_, _, _):
            return .empty()
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCategory(let category):
            newState.category = category
            return newState
        case .setEditMode(let mode):
            newState.editMode = mode
            return newState
        case .setQuestion(let question):
            newState.question = question
            return newState
        case .setAnswer(let answer):
            newState.answer = answer
            return newState
        case .setSaveResult(_, _):
            return newState
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
