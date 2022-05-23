//
//  MainTabViewModel.swift
//  DevSheet
//
//  Created by yongmin lee on 5/20/22.
//

import Foundation
import RxRelay
import RxSwift

struct MainTabViewModel {
    let tabItems = BehaviorRelay<[MainTab]>(value: MainTab.allCases)
}
