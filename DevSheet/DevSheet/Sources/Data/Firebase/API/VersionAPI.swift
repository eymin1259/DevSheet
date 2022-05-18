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
    
    var collectoin : CollectionReference {
        return Firestore.firestore().collection("version")
    }
    
    func task() -> Single<QuerySnapshot> {
        switch self {
        case .getVersionCheck:
            return Single<QuerySnapshot>.create { single in
                collectoin.order(by: "timeStamp", descending: true).getDocuments { snapshot, err in
                    if let err = err {
                        single(.failure(err))
                    }
                    if let  snapshot = snapshot,
                       snapshot.isEmpty == false
                    {
                        single(.success(snapshot))
                    }
                    else{
                        single(.failure(FirebaseError.noData))
                    }
                }
                return Disposables.create()
            }
        }
    }
}
