//
//  MockCategoryRepository.swift
//  DevSheetTests
//
//  Created by yongmin lee on 6/12/22.
//

import Foundation
import XCTest
import RxSwift
@testable import DevSheet

final class MockCategoryRepository: CategoryRepository {
    
    private var makeFailureReturn = false
    
    init(makeFailureReturn: Bool) {
        self.makeFailureReturn = makeFailureReturn
    }
    
    func fetchAllCategories(group: MainTab) -> Single<[DevSheet.Category]> {
        return Single<[DevSheet.Category]>.create { [weak self] single in
            guard let self = self else {
                single(.failure(FirebaseError.unknown))
                return Disposables.create()
            }
            if self.makeFailureReturn {
                single(.failure(FirebaseError.unknown))
            } else {
                let sampleData: [DevSheet.Category] = [
                    .init(
                        id: "JJaJsmDACazr5eyJO3rs",
                        name: "Frontend",
                        groupId: 1,
                        imageUrl: "",
                        orderNumber: 1,
                        createdAt: "2022-05-29",
                        deleted: false
                    ),
                    .init(
                        id: "lTN6FFKIFiz2VCyexGux",
                        name: "Backend",
                        groupId: 1,
                        imageUrl: "",
                        orderNumber: 2,
                        createdAt: "2022-05-29",
                        deleted: false
                    ),
                    .init(
                        id: "AkLfXORC2fR3xYnRkLaM",
                        name: "Android",
                        groupId: 1,
                        imageUrl: "",
                        orderNumber: 3,
                        createdAt: "2022-05-29",
                        deleted: false
                    ),
                    .init(
                        id: "JyBS75rSWeZbepgEbyp8",
                        name: "iOS",
                        groupId: 1,
                        imageUrl: "",
                        orderNumber: 4,
                        createdAt: "2022-05-29",
                        deleted: false
                    )
                ]
                single(.success(sampleData))
            }
            return Disposables.create()
        }
    }
    
    func fetchAllFavoriteCategories() -> Single<[DevSheet.Category]> {
        return Single<[DevSheet.Category]>.create { [weak self] single in
            guard let self = self else {
                single(.failure(FirebaseError.unknown))
                return Disposables.create()
            }
            if self.makeFailureReturn {
                single(.failure(FirebaseError.unknown))
            } else {
                let sampleData: [DevSheet.Category] = []
                single(.success(sampleData))
            }
            return Disposables.create()
        }
    }
    
    func saveFavoriteCategory(category: DevSheet.Category) -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            guard let self = self else {
                single(.failure(FirebaseError.unknown))
                return Disposables.create()
            }
            if self.makeFailureReturn {
                single(.failure(FirebaseError.unknown))
            } else {
                single(.success(true))
            }
            return Disposables.create()
        }
    }
}
