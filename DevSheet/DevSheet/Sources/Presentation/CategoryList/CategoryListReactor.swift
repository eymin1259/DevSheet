//
//  CategoryListReactor.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import ReactorKit

final class CategoryListReactor: Reactor {

    // MARK: properties
    enum Action {
        case viewDidAppear(MainTab?)
    }
    
    enum Mutation {
        case setCategories([Category])
        case setLoading(Bool)
    }
    
    struct State {
        var categorySections: [CategoryListSection] = [.init(categoryList: [])]
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
    var categoryUseCase: CategoryUseCase
    
    // MARK: initialize
    init(categoryUseCase: CategoryUseCase) {
        self.categoryUseCase = categoryUseCase
    }
}

extension CategoryListReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear(let group):
            guard let group = group else { return .empty() }
            guard !self.currentState.isLoading else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setCategories = self.categoryUseCase.fetchCategories(group: group)
                .asObservable()
                .catchAndReturn([])
                .map { categoryList -> Mutation in
                    return .setCategories(categoryList)
                }
            return .concat([startLoading, setCategories, endLoading])
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCategories(let list):
            newState.categorySections = [.init(categoryList: list)]
            return newState
            
        case .setLoading(let loading):
            newState.isLoading = loading
            return newState
        }
    }
}
