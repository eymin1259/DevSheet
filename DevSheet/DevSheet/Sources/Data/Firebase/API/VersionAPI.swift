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
    
    func task() -> Single<Query> {
        switch self {
        case .getVersionCheck:
            return Single<Query>.create { single in
                single(.success(
                    collection
                        .order(by: "timeStamp", descending: true)
                        .limit(to: 1)
                ))
                return Disposables.create()
            }
        }
    }
}
