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
    func fetchCategories(query: String) -> Single<[Category]> {
        <#code#>
    }
}
