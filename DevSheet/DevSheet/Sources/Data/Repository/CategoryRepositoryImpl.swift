//
//  CategoryRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift
import Firebase

final class CategoryRepositoryImpl: CategoryRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    
    // MARK: initialize
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: methods
    func fetchCategories(group: MainTab) -> Single<[Category]> {
        return firebaseService
            .request(
                CategoryAPI.fetchCategories(group: group.rawValue)
            )
            .map { snapshot in
                var ret = [Category]()
                for doc in snapshot.documents {
                    let id = doc.documentID
                    let data = doc.data()
                    let category = CategoryDTO(id: id, dictionary: data).toDomain()
                    ret.append(category)
                }
                return ret
            }
    }
}
