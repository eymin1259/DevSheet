//
//  CategoryQuery.swift
//  DevSheet
//
//  Created by yongmin lee on 6/6/22.
//

import Foundation

enum CategoryQuery {
    case createCategoryTable
    case selectAllFavoriteCategories
    case insertCategory(CategoryDTO)
}

extension CategoryQuery: SQLiteQuery {
    
    func getQuery() -> String {
        switch self {
        case .createCategoryTable:
            return "CREATE TABLE IF NOT EXISTS Categories (id TEXT PRIMARY KEY, name TEXT , groupId INTEGER , imageUrl TEXT, orderNumber INTEGER, timeStamp TEXT , deleted INTEGER);"
            
        case .selectAllFavoriteCategories:
            return "SELECT * FROM Categories WHERE deleted = '0' ORDER BY groupId ASC, orderNumber ASC;"
            
        case .insertCategory(let categoryDTO):
            let deletedInt = categoryDTO.deleted ? 1 : 0
            return "INSERT INTO Categories (id, name, groupId, imageUrl, orderNumber, timeStamp, deleted) VALUES ('\(categoryDTO.id)', '\(categoryDTO.name)', '\(categoryDTO.groupId)', '\(categoryDTO.imageUrl)', '\(categoryDTO.orderNumber)', '\(categoryDTO.timeStamp)', '\(deletedInt)'); "
        }
    }
}
