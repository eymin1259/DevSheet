//
//  ServiceAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import Firebase
import RxSwift

protocol ServiceAPI {
    var collection: CollectionReference { get }
    func task() -> Single<QuerySnapshot>
}
