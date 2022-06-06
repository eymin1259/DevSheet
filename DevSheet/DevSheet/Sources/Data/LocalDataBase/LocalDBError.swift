//
//  LocalDBError.swift
//  DevSheet
//
//  Created by yongmin lee on 6/6/22.
//

import Foundation

enum LocalDBError: Error {
    case connectionFail
    case write
    case read
    case unknown
}

extension LocalDBError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .connectionFail:
            return "LocalDB connection fail error"
        case .write:
            return "LocalDB write error"
        case .read:
            return "LocalDB read error"
        case .unknown:
            return "LocalDB unknown error"
        }
    }
}
