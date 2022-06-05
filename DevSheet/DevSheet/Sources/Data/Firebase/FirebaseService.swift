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
    func get(_ api: ServiceAPI) -> Single<QuerySnapshot>
    func post(_ api: ServiceAPI) -> Single<DocumentReference>
}

final class FirebaseServiceImpl: FirebaseService {

    func get(_ api: ServiceAPI) -> Single<QuerySnapshot> {
        BeaverLog.debug("FirebaseService GET api :", context: api)
        return Single<QuerySnapshot>.create { single in
            guard let query = api.get() else {
                single(.failure(FirebaseError.unknown))
                return Disposables.create()
            }
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
    
    func post(_ api: ServiceAPI) -> Single<DocumentReference> {
        BeaverLog.debug("FirebaseService POST api :", context: api)
        return Single<DocumentReference>.create { single in
            api.post { err, docRef in
                if let err = err {
                    single(.failure(err))
                } else if let docRef = docRef {
                    single(.success(docRef))
                } else {
                    single(.failure(FirebaseError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}
