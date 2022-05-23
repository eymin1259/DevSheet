//
//  CategoryUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift

protocol CategoryUseCase {
    func fetchCategories(query: String) -> Single<[Category]>
}

final class  CategoryUseCaseImpl: CategoryUseCase {
    
    // MARK: properties
    var categoryRepository: CategoryRepository
    
    // MARK: initialize
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    // MARK: methods
    func fetchCategories(query: String) -> Single<[Category]> {
        
    }
}
