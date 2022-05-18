//
//  SplashUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation

protocol SplashUseCase {
    func checkShouldUpdate() -> Bool
}

final class  SplashUseCaseImpl: SplashUseCase {
    
    // MARK: properties
    var repository: SplashRepository
    
    // MARK: initialize
    init(repository: SplashRepository) {
        self.repository = repository
    }
    
    // MARK: methods
    func checkShouldUpdate() -> Bool {
        return false
    }
}
