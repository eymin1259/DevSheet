//
//  CategoryList.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation

struct CategoryList: Equatable {
    var items: [Category]
    
    static func == (lhs: CategoryList, rhs: CategoryList) -> Bool {
        
        var compare = true
        let lhsCount = lhs.items.count
        let rhsCount  = rhs.items.count
        if lhsCount != rhsCount {
            return false
        }
        
        for idx in 0..<lhsCount {
            if lhs.items[idx].id != rhs.items[idx].id {
                compare = false
                break
            }
        }
        return compare
    }
}
