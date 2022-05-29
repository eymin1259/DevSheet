//
//  CategoryRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import  RxSwift

protocol CategoryRepository {
    func fetchCategories(group: MainTab) -> Single<[Category]>
}
