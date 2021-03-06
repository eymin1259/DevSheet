//
//  CategoryUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift

protocol CategoryUseCase {
    func fetchAllCategories(group: MainTab) -> Single<[Category]>
    func fetchAllFavoriteCategories() -> Single<[Category]>
    func saveFavoriteCategory(category: Category) -> Single<Bool>
}

final class  CategoryUseCaseImpl: CategoryUseCase {
    
    // MARK: properties
    var categoryRepository: CategoryRepository
    
    // MARK: initialize
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    // MARK: methods
    func fetchAllCategories(group: MainTab) -> Single<[Category]> {
        return categoryRepository.fetchAllCategories(group: group)
    }
    
    func fetchAllFavoriteCategories() -> Single<[Category]> {
        return categoryRepository.fetchAllFavoriteCategories()
    }
    
    func saveFavoriteCategory(category: Category) -> Single<Bool> {
        return categoryRepository.fetchAllFavoriteCategories()
            .flatMap { [unowned self] categoryList -> Single<Bool> in
                let favoriteCategories = categoryList.filter { favCategory in
                    favCategory.id == category.id
                }
                if favoriteCategories.isEmpty {
                    return categoryRepository.saveFavoriteCategory(category: category)
                } else {
                    return Single<Bool>.just(true)
                }
            }
    }
}
