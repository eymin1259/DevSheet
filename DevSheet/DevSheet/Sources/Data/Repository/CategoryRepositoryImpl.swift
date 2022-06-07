//
//  CategoryRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift
import Firebase
import SQLite3

final class CategoryRepositoryImpl: CategoryRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    var sqliteService: SQLiteService
    
    // MARK: initialize
    init(
        firebaseService: FirebaseService,
        sqliteService: SQLiteService
    ) {
        self.firebaseService = firebaseService
        self.sqliteService = sqliteService
    }
    
    // MARK: methods
    func fetchCategories(group: MainTab) -> Single<[Category]> {
        if group == .favorite {
            return fetchAllFavoriteCategories()
        } else { // .cs or .develop
            return firebaseService
                .get(
                    CategoryAPI.getCategories(groupId: group.rawValue)
                )
                .map { snapshot in
                    var ret = [Category]()
                    for doc in snapshot.documents {
                        let id = doc.documentID
                        let data = doc.data()
                        let category = CategoryDTO(id: id, dictionary: data).toDomain()
                        ret.append(category)
                    }
                    return ret
                }
        }
    }
    
    func fetchAllFavoriteCategories() -> Single<[Category]> {
        return Single<[Category]>.create { [unowned self] single in
            var result = [Category]()
            sqliteService.read(query: CategoryQuery.selectAllFavoriteCategories) { row in
                let id = String(cString: sqlite3_column_text(row, 0))
                let name = String(cString: sqlite3_column_text(row, 1))
                let groupId = Int(sqlite3_column_int(row, 2))
                let imageUrl = String(cString: sqlite3_column_text(row, 3))
                let orderNumber = Int(sqlite3_column_int(row, 4))
                let timeStamp = String(cString: sqlite3_column_text(row, 5))
                let deletedInt = Int(sqlite3_column_int(row, 6))
                let dto = CategoryDTO(id: id, dictionary: [
                    "id": id,
                    "name": name,
                    "groupId": groupId,
                    "imageUrl": imageUrl,
                    "orderNumber": orderNumber,
                    "timeStamp": timeStamp,
                    "deleted": deletedInt == 0 ? false : true
                    
                ])
                result.append(dto.toDomain())
            } errorHandler: { err in
                single(.failure(err))
            }
            single(.success(result))
            return Disposables.create()
        }
    }
    
    func saveFavoriteCategory(category: Category) -> Single<Bool> {
        let categoryDTO = CategoryDTO(
            id: category.id,
            dictionary: [
                "name": category.name,
                "groupId": category.groupId,
                "imageUrl": category.imageUrl,
                "orderNumber": category.orderNumber,
                "timeStamp": category.createdAt,
                "deleted": category.deleted
            ])
        return sqliteService.create(query: CategoryQuery.insertCategory(categoryDTO))
    }
}
