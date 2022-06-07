//
//  SQLiteService.swift
//  DevSheet
//
//  Created by yongmin lee on 6/6/22.
//

import Foundation
import RxSwift

protocol SQLiteService {
    func create(
        query: SQLiteQuery
    ) -> Single<Bool>
    
    func read(
        query: SQLiteQuery,
        rowHandler: @escaping(OpaquePointer) -> Void,
        errorHandler: @escaping(Error) -> Void
    )
}

final class SQLiteServiceImpl: SQLiteService {
    func create(
        query: SQLiteQuery
    ) -> Single<Bool> {
        BeaverLog.debug("SQLiteService create : ", context: query)
        return Single<Bool>.create { single in
            do {
                let db = try WrappedSQLite()
                try db.install(query: query.getQuery())
                try db.execute()
                single(.success(true))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func read(
        query: SQLiteQuery,
        rowHandler: @escaping(OpaquePointer) -> Void,
        errorHandler: @escaping(Error) -> Void
    ) {
        BeaverLog.debug("SQLiteService read : ", context: query)
        do {
            let db = try WrappedSQLite()
            try db.install(query: query.getQuery())
            try db.execute(rowHandler: rowHandler)
        } catch {
            errorHandler(error)
        }
    }
}
