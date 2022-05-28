//
//  CategoryListSection.swift
//  DevSheet
//
//  Created by yongmin lee on 5/24/22.
//

import Foundation
import RxDataSources

struct CategoryListSection {
    var categoryList: [Category]
}

extension CategoryListSection: SectionModelType {
    
    var items: [Category] {
        return self.categoryList
    }
    
    init(original: CategoryListSection, items: [Category]) {
        self = original
        self.categoryList = items
    }
}
