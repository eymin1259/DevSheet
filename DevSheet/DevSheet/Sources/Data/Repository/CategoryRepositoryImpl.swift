//
//  CategoryRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import RxSwift
import Firebase
import RealmSwift

final class CategoryRepositoryImpl: CategoryRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    var localDBService: LocalDBService
    
    // MARK: initialize
    init(
        firebaseService: FirebaseService,
        localDBService: LocalDBService
    ) {
        self.firebaseService = firebaseService
        self.localDBService = localDBService
    }
    
    // MARK: methods
    func fetchCategories(group: MainTab) -> Single<[Category]> {
        
        if group == .favorite {
            return Single<[Category]>.create { [weak self] single in
                guard let self = self else {
                    single(.failure(NSError(domain: "RepoRefError", code: -1, userInfo: nil)))
                    return Disposables.create()
                }
                let results = self.localDBService.fetch(object: CategoryDTO.self)
                var categoryList: [Category] = .init()
                results.forEach { dto in
                    categoryList.append(dto.toDomain())
                }
                single(.success(categoryList))
                return Disposables.create()
            }
        } else { // .cs or .develop
            return firebaseService
                .get(
                    CategoryAPI.getCategories(group: group.rawValue)
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
    
    func fetchFavoriteCategories() -> [Category] {
        let results = localDBService.fetch(object: CategoryDTO.self)
        var ret: [Category] = .init()
        results.forEach { dto in
            ret.append(dto.toDomain())
        }
        return ret
    }
    
    func saveFavoriteCategory(category: Category) -> Single<Bool> {
        let categoryDTO = CategoryDTO(
            id: category.id,
            dictionary: [
                "name": category.name,
                "group": category.group,
                "imageUrl": category.imageUrl,
                "order": category.order,
                "timeStamp": category.createdAt,
                "deleted": category.deleted
            ])
        return localDBService.write(object: categoryDTO)
    }
}
