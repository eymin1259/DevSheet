//
//  ServiceAPI.swift
//  DevSheet
//
//  Created by yongmin lee on 5/18/22.
//

import Foundation
import Firebase

protocol ServiceAPI {
    var collection: CollectionReference { get }
    func task() -> Query
}
