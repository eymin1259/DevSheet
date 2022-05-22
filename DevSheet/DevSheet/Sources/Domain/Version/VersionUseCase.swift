//
//  VersionUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation
import RxSwift

protocol VersionUseCase {
    func checkShouldUpdate() -> Single<Bool>
}

final class  VersionUseCaseImpl: VersionUseCase {
    // MARK: properties
    var versionRepository: VersionRepository
    
    // MARK: initialize
    init(versionRepository: VersionRepository) {
        self.versionRepository = versionRepository
    }
    
    // MARK: methods
    func checkShouldUpdate() -> Single<Bool> {
        return versionRepository.getVersionCheck()
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
