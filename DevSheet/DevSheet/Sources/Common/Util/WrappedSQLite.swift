//
//  WrappedSQLite.swift
//  DevSheet
//
//  Created by yongmin lee on 6/6/22.
//

import Foundation
import SQLite3

class WrappedSQLite {
    
    // MARK: properties
    enum SQLError: Error {
        case connectionError
        case queryError
        case otherError
    }
    
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    let path: String = {
        let fm = FileManager.default
        return fm
            .urls(
                for: .libraryDirectory,
                in: .userDomainMask
            )
            .last!
            .appendingPathComponent("data.db").path
    }()
    
    // MARK: initialize
    init() throws {
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            throw SQLError.connectionError
        }
    }
    
    deinit {
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }
    
    // MARK: methods
    func install(query: String) throws {
        sqlite3_finalize(stmt)
        stmt = nil
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            return
        }
        throw SQLError.queryError
    }
    
    func execute(rowHandler: ((OpaquePointer) -> Void)? = nil) throws {
        while true {
            switch sqlite3_step(stmt) {
            case SQLITE_DONE:
                return
            case SQLITE_ROW:
                rowHandler?(stmt!)
            default:
                throw SQLError.otherError
            }
        }
    }
}
