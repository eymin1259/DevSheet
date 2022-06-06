//
//  VersionRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation
import RxSwift
import Firebase

final class VersionRepositoryImpl: VersionRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    var sqliteService: SQLiteService
    
    // MARK: initialize
    init(
        firebaseService: FirebaseService,
        sqliteService: SQLiteService
    ) {
        self.firebaseService = firebaseService
        self.sqliteService = sqliteService
    }
    
    // MARK: methods
    func createTables()  -> Single<Bool> {
        return sqliteService.create(query: CategoryQuery.createCategoryTable)
            .flatMap { [unowned self] result in
                if result {
                    return sqliteService.create(query: QuestionQuery.createQuestionTable)
                } else {
                    return  Single<Bool>.just(false)
                }
            }
    }
    
    func getVersionCheck() -> Single<Version> {
        return firebaseService
            .get(VersionAPI.getVersionCheck)
            .map { snapshot in
                let id = snapshot.documents.first!.documentID
                let data = snapshot.documents.first!.data()
                let version = VersionDTO(id: id, dictionary: data).toDomain()
                return version
            }
    }
}
