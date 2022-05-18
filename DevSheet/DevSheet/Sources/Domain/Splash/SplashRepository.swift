//
//  SplashRepository.swift
//  DevSheet
//
//  Created by yongmin lee on 5/17/22.
//

import Foundation
import  RxSwift

protocol SplashRepository {
    func getVersionCheck() -> Single<Entity.Version>
}
