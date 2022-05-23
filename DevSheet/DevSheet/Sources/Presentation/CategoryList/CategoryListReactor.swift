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
        case viewDidLoad
    }
    
    enum Mutation {
        case checkUpdate(Bool)
    }
    
    struct State {
        var shouldUpdate: Bool?
    }
    
    let initialState: State = .init()
    var categoryUseCase: CategoryUseCase
    
    // MARK: initialize
    init(categoryUseCase: CategoryUseCase) {
        self.categoryUseCase = categoryUseCase
    }
}
