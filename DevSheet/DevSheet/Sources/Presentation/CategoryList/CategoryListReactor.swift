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
        case viewDidAppear
    }
    
    enum Mutation {
        case setCategories([Category])
        case setLoading(Bool)
    }
    
    struct State {
        var categoryGroup: MainTab
        var categorySections: [CategoryListSection] = [.init(categoryList: [])]
        var isLoading: Bool = false
    }
    
    let initialState: State
    var categoryUseCase: CategoryUseCase
    
    // MARK: initialize
    init(
        categoryGroup: MainTab,
        categoryUseCase: CategoryUseCase
    ) {
        self.initialState = .init(categoryGroup: categoryGroup)
        self.categoryUseCase = categoryUseCase
    }
}

extension CategoryListReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            guard !self.currentState.isLoading else { return .empty() }
            let categoryGroup = self.currentState.categoryGroup
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            var fetchCategories: Single<[Category]>
            if categoryGroup == .favorite {
                fetchCategories = self.categoryUseCase.fetchAllFavoriteCategories()
            } else {
                fetchCategories = self.categoryUseCase.fetchAllCategories(group: categoryGroup)
            }
            let setCategories = fetchCategories
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
