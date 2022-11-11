//
//  MainTab.swift
//  DevSheet
//
//  Created by yongmin lee on 5/20/22.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case cs
    case develop
    case favorite
}

extension MainTab: CustomStringConvertible {
    var description: String {
        switch self {
        case .cs: return "컴퓨터과학"
        case .develop: return "개발"
        case .favorite: return "즐겨찾기"
        }
    }
}

extension MainTab {
    var activeIcon: UIImage? {
        switch self {
        case .cs:
            return UIImage(named: "icon_cs_active")?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            )
        case .develop:
            return UIImage(named: "icon_develop_active")?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            )
        case .favorite:
            return UIImage(named: "icon_favorite_active")?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            )
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .cs:
            return UIImage(named: "icon_cs")?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            )
        case .develop:
            return UIImage(named: "icon_develop")?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            )
        case .favorite:
            return UIImage(named: "icon_favorite")?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            )
        }
    }
}

extension MainTab {
    func getTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: description,
            image: icon,
            selectedImage: activeIcon
        )
    }
}
