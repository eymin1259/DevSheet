//
//  CategoryRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import  RxSwift

protocol CategoryRepository {
    func fetchAllCategories(group: MainTab) -> Single<[Category]>
    func fetchAllFavoriteCategories() -> Single<[Category]>
    func saveFavoriteCategory(category: Category) -> Single<Bool>
}
