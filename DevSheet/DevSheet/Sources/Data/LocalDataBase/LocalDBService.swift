//
//  LocalDBService.swift
//  DevSheet
//
//  Created by yongmin lee on 6/6/22.
//

import Foundation
import RxSwift
import RealmSwift

protocol LocalDBService {
    func write(object: Object) -> Single<Bool>
    func fetch<T: Object>(object: T.Type) -> Results<T>
}

final class LocalDBServiceImpl: LocalDBService {
    
    // MARK: Properties
    var realm: Realm
    
    // MARK: initialize
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Realm init error")
        }
    }
    
    // MARK: methods
    func write(object: Object) -> Single<Bool> {
        BeaverLog.debug("Realm write : ", context: object)
        return Single<Bool>.create { [weak self] single in
            guard let self = self else {
                single(.failure(LocalDBError.connectionFail))
                return Disposables.create()
            }
            do {
                try self.realm.write {
                    self.realm.add(object)
                    single(.success(true))
                }
            } catch {
                BeaverLog.debug("Realm write error : ", context: error)
                single(.failure(LocalDBError.write))
            }
            return Disposables.create()
        }
    }
    
    func fetch<T: Object>(object: T.Type) -> Results<T> {
        BeaverLog.debug("Realm fetch : ", context: object)
        return realm.objects(object)
    }
}
