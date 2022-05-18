//
//  FirebaseError.swift
//  DevSheet
//
//  Created by yongmin lee on 5/19/22.
//

import Foundation

enum FirebaseError: Error {
    case noData
    case unknown
}

extension FirebaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Firebase no data error"
        case .unknown:
            return "Firebase unknown error"
        }
    }
}
