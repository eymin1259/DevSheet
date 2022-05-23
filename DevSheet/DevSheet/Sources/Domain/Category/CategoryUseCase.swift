//
//  CategoryUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift

protocol CategoryUseCase {
    func fetchCategories(group: MainTab) -> Single<CategoryList>
}

final class  CategoryUseCaseImpl: CategoryUseCase {
    
    // MARK: properties
    var categoryRepository: CategoryRepository
    
    // MARK: initialize
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    // MARK: methods
    func fetchCategories(group: MainTab) -> Single<CategoryList> {
        return categoryRepository.fetchCategories(group: group.rawValue)
            .map { list in return CategoryList(items: list) }
    }
}
