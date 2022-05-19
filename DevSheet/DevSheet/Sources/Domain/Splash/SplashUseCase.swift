//
//  SplashUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation
import RxSwift

protocol SplashUseCase {
    func checkShouldUpdate() -> Single<Bool>
}

final class  SplashUseCaseImpl: SplashUseCase {
    
    // MARK: properties
    var repository: SplashRepository
    
    // MARK: initialize
    init(repository: SplashRepository) {
        self.repository = repository
    }
    
    // MARK: methods
    func checkShouldUpdate() -> Single<Bool> {
        return repository.getVersionCheck()
            .map { response in
                guard let dictionary = Bundle.main.infoDictionary,
                      let versionStr = dictionary["CFBundleShortVersionString"] as? String,
                      let deviceVersion = Float(versionStr),
                      let releaseVersion = Float(response.version)
                else {
                    return false
                }
                
                if deviceVersion >= releaseVersion {
                    return false
                } else if response.shouldUpdate == true {
                    return true
                } else {
                    return false
                }
            }
    }
}
