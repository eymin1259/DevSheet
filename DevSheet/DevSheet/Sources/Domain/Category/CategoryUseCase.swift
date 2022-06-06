//
//  CategoryUseCase.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift

protocol CategoryUseCase {
    func fetchCategories(group: MainTab) -> Single<[Category]>
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
    func fetchCategories(group: MainTab) -> Single<[Category]> {
        return categoryRepository.fetchCategories(group: group)
    }
    
    func saveFavoriteCategory(category: Category) -> Single<Bool> {
//        let favoriteCategories = categoryRepository.fetchFavoriteCategories().filter { favCategory in
//            favCategory.id == category.id
//        }
//        if favoriteCategories.isEmpty {
//            return categoryRepository.saveFavoriteCategory(category: category)
//        } else {
//            return Single<Bool>.just(true)
//        }
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
