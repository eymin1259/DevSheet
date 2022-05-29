//
//  FirebaseService.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import RxSwift
import Firebase

protocol FirebaseService {
    func request(_ api: ServiceAPI) -> Single<QuerySnapshot>
}

final class FirebaseServiceImpl: FirebaseService {
    
    func request(_ api: ServiceAPI) -> Single<QuerySnapshot> {
        beaverLog.debug("api :", context: api)
        return api.task()
            .flatMap { query in
                return Single<QuerySnapshot>.create { single in
                    query.getDocuments { snapshot, err in
                        if let err = err {
                            single(.failure(err))
                        }
                        if let  snapshot = snapshot,
                           snapshot.isEmpty == false {
                            single(.success(snapshot))
                        } else {
                            single(.failure(FirebaseError.noData))
                        }
                    }
                    return Disposables.create()
                }
            }
    }
}
