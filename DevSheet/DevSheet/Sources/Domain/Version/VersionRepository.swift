//
//  VersionRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation
import  RxSwift

protocol VersionRepository {
    func getVersionCheck() -> Single<Version>
}
