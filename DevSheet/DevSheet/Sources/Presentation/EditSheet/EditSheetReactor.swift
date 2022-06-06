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
        case viewDidLoad(SheetEditMode, String, Question?, String?) 
        case inputQuestion(String)
        case inputAnswer(String)
        case tapSaveBtn
    }
    
    enum Mutation {
        case setEditMode(SheetEditMode)
        case setCategoryId(String)
        case setQuestion(Question?)
        case setQuestionText(String?)
        case setAnswerText(String?)
        case setSaveResult(Bool)
        case setErrorMessage(String?)
        case setLoading(Bool)
    }
    
    struct State {
        var editMode: SheetEditMode?
        var categoryId: String?
        var question: Question?
        var questionText: String?
        var answerText: String?
        var saveResult: Bool?
        var errorMessage: String?
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
    var sheetUseCase: SheetUseCase
    
    // MARK: initialize
    init(sheetUseCase: SheetUseCase) {
        self.sheetUseCase = sheetUseCase
    }
}

extension EditSheetReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let mode, let categoryId, let question, let answer):
            let setEditMode = Observable<Mutation>.just(.setEditMode(mode))
            let setCategoryId = Observable<Mutation>.just(.setCategoryId(categoryId))
            let setQuestion =  Observable<Mutation>.just(.setQuestion(question))
            let setQuestionText = Observable<Mutation>.just(.setQuestionText(mode == .ADD ? nil : question?.title))
            let setAnswerText = Observable<Mutation>.just(.setAnswerText(mode == .ADD ? nil : answer))
            return .concat([setCategoryId, setEditMode, setQuestion, setQuestionText, setAnswerText])
            
        case .inputQuestion(let questionText):
            return Observable<Mutation>.just(.setQuestionText(questionText))
            
        case .inputAnswer(let answerText):
            return Observable<Mutation>.just(.setAnswerText(answerText))
            
        case .tapSaveBtn:
            guard !self.currentState.isLoading else { return .empty() }
            guard let editMode = self.currentState.editMode else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            var setSheet: Observable<EditSheetReactor.Mutation>
            if editMode == .ADD {
                guard let categoryId = self.currentState.categoryId else { return .empty() }
                setSheet = sheetUseCase
                    .addNewSheet(
                        categoryId: categoryId,
                        questionText: self.currentState.questionText,
                        answerText: self.currentState.answerText
                    )
                    .asObservable()
                    .map { result -> EditSheetReactor.Mutation  in
                        return EditSheetReactor.Mutation.setSaveResult(result)
                    }
                    .catch { err in
                        return Observable<EditSheetReactor.Mutation>.just(.setErrorMessage(err.localizedDescription))
                    }
            } else { // .UPDATE
                guard let question = self.currentState.question else { return .empty() }
                setSheet = sheetUseCase
                    .updateSheet(
                        question: question,
                        questionText: self.currentState.questionText,
                        answerText: self.currentState.answerText
                    )
                    .asObservable()
                    .map { result -> EditSheetReactor.Mutation  in
                        return EditSheetReactor.Mutation.setSaveResult(result)
                    }
                    .catch { err in
                        return Observable<EditSheetReactor.Mutation>.just(.setErrorMessage(err.localizedDescription))
                    }
            }
            return .concat([startLoading, setSheet, endLoading])
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEditMode(let mode):
            newState.editMode = mode
            return newState
            
        case .setCategoryId(let categoryId):
            newState.categoryId = categoryId
            return newState
            
        case .setQuestion(let question):
            newState.question = question
            return newState
            
        case .setQuestionText(let questionText):
            var textChecked = questionText
            if textChecked == SheetEditMode.UPDATE.defaultQuestoin ||
                textChecked == SheetEditMode.ADD.defaultQuestoin {
                textChecked = nil
            }
            newState.questionText = textChecked
            return newState
            
        case .setAnswerText(let answerText):
            var textChecked = answerText
            if textChecked == SheetEditMode.UPDATE.defaultAnswer ||
                textChecked == SheetEditMode.ADD.defaultAnswer {
                textChecked = nil
            }
            newState.answerText = textChecked
            return newState
            
        case .setSaveResult(let result):
            newState.saveResult = result
            return newState
            
        case .setErrorMessage(let msg):
            newState.errorMessage = msg
            return newState
            
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
