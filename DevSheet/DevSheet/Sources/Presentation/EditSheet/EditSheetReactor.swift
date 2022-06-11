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
        case viewDidLoad
        case inputQuestion(String)
        case inputAnswer(String)
        case tapSaveBtn
    }
    
    enum Mutation {
        case setQuestionText(String?)
        case setAnswerText(String?)
        case setSaveResult(Bool)
        case setErrorMessage(String?)
        case setLoading(Bool)
    }
    
    struct State {
        var editMode: SheetEditMode
        var categoryId: String
        var question: Question?
        var questionText: String?
        var answerText: String?
        var saveResult: Bool?
        var errorMessage: String?
        var isLoading: Bool = false
    }
    
    let initialState: State
    var sheetUseCase: SheetUseCase
    
    // MARK: initialize
    init(
        editMode: SheetEditMode,
        categoryId: String,
        question: Question?,
        answerText: String,
        sheetUseCase: SheetUseCase
    ) {
        self.initialState = .init(
            editMode: editMode,
            categoryId: categoryId,
            question: question,
            answerText: answerText
        )
        self.sheetUseCase = sheetUseCase
    }
}

extension EditSheetReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let setQuestionText = Observable<Mutation>.just(
                .setQuestionText(
                    self.currentState.editMode == .ADD ? nil : self.initialState.question?.title
                )
            )
            let setAnswerText = Observable<Mutation>.just(
                .setAnswerText(
                    self.currentState.editMode == .ADD ? nil : self.initialState.answerText
                )
            )
            return .concat([
                setQuestionText, setAnswerText
            ])
            
        case .inputQuestion(let questionText):
            return Observable<Mutation>.just(.setQuestionText(questionText))
            
        case .inputAnswer(let answerText):
            return Observable<Mutation>.just(.setAnswerText(answerText))
            
        case .tapSaveBtn:
            guard !self.currentState.isLoading else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            var editSheet: Single<Bool>
            if self.currentState.editMode == .ADD {
                editSheet = sheetUseCase.addNewSheet(
                    categoryId: self.currentState.categoryId,
                    questionText: self.currentState.questionText,
                    answerText: self.currentState.answerText
                )
            } else { // .UPDATE
                guard let question =  self.currentState.question else { return .empty() }
                editSheet = sheetUseCase.updateSheet(
                    question: question,
                    questionText: self.currentState.questionText,
                    answerText: self.currentState.answerText
                )
            }
            let setSheet = editSheet
                .asObservable()
                .map { result -> EditSheetReactor.Mutation  in
                    return EditSheetReactor.Mutation.setSaveResult(result)
                }
                .catch { err in
                    return Observable<EditSheetReactor.Mutation>.just(
                        .setErrorMessage(err.localizedDescription)
                    )
                }
            return .concat([startLoading, setSheet, endLoading])
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
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
