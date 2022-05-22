//
//  VersionAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import Firebase
import RxSwift

enum VersionAPI {
    case getVersionCheck
}

extension VersionAPI: ServiceAPI {
    
    var collection: CollectionReference {
        return Firestore.firestore().collection("versions")
    }
    
    func task() -> Single<QuerySnapshot> {
        switch self {
        case .getVersionCheck:
            return Single<QuerySnapshot>.create { single in
                collection
                    .order(by: "timeStamp", descending: true)
                    .limit(to: 1)
                    .getDocuments { snapshot, err in
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
