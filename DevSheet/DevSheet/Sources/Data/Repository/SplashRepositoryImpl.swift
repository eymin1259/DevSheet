//
//  SplashRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation

final class SplashRepositoryImpl: SplashRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    
    // MARK: initialize
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: methods
    func getAppVersion() {
        //
    }
}
