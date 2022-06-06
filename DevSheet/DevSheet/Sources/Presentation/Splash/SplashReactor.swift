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
        case viewDidAppear
    }
    
    enum Mutation {
        case setDBInit(Bool)
        case checkUpdate(Bool)
    }
    
    struct State {
        var dbInit: Bool?
        var shouldUpdate: Bool?
    }
    
    let initialState: State = .init()
    var versionUseCase: VersionUseCase
    
    // MARK: initialize
    init(versionUseCase: VersionUseCase) {
        self.versionUseCase = versionUseCase
    }
}

extension SplashReactor {
    // MARK: Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            let setDBInit = versionUseCase
                .createTables()
                .asObservable()
                .catchAndReturn(false)
                .map(SplashReactor.Mutation.setDBInit)
            
            let checkUpdate = versionUseCase
                .checkShouldUpdate()
                .asObservable()
                .catchAndReturn(true)
                .map(Mutation.checkUpdate)
            
            return .concat([setDBInit, checkUpdate])
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .checkUpdate(let shouldUpdate):
            newState.shouldUpdate = shouldUpdate
            return newState
            
        case .setDBInit(let result):
            newState.dbInit = result
            return newState
        }
    }
}
