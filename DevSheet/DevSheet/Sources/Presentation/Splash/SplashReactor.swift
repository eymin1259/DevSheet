//
//  SplashReactor.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import ReactorKit

final class SplashReactor: Reactor {

    // MARK: properties
    enum Action {
        case loadMore
    }
    
    enum Mutation {
        case setLoading(Bool)
        case showError(Error)
    }
    
    struct State {
        var shouldUpdate: Bool = false
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
    var splashUseCase: SplashUseCase
    
    // MARK: initialize
    init(splashUseCase: SplashUseCase) {
        self.splashUseCase = splashUseCase
    }
}
