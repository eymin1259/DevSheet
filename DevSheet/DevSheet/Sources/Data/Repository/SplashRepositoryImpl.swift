//
//  SplashRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation
import RxSwift
import Firebase

final class SplashRepositoryImpl: SplashRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    
    // MARK: initialize
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: methods
    func getVersionCheck() -> Single<Entity.Version> {
        return firebaseService.request(VersionAPI.getVersionCheck)
            .map { snapshot in
                let id = snapshot.documents.first!.documentID
                let data = snapshot.documents.first!.data()
                let version = Entity.Version(id: id, dictionary: data)
                return version
            }
    }
}
