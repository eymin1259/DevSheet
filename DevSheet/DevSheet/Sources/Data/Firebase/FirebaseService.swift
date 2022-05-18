//
//  FirebaseService.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import RxSwift
import  Firebase

protocol FirebaseService {
    func request(_ api: ServiceAPI) -> Single<QuerySnapshot>
}

final class FirebaseServiceImpl: FirebaseService {
    
    func request(_ api: ServiceAPI) -> Single<QuerySnapshot> {
       return api.task()
    }
}
