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
    case mypage
}

extension MainTab: CustomStringConvertible {
    var description: String {
        switch self {
        case .cs: return "컴퓨터과학"
        case .develop: return "개발"
        case .favorite: return "즐겨찾기"
        case .mypage: return "마이페이지"
        }
    }
}

extension MainTab {
    var activeIcon: UIImage? {
        switch self {
        case .cs:
            return UIImage(named: "icon_cs_active")?.withRenderingMode(.alwaysTemplate)
        case .develop:
            return UIImage(named: "icon_develop_active")?.withRenderingMode(.alwaysTemplate)
        case .favorite:
            return UIImage(named: "icon_favorite_active")?.withRenderingMode(.alwaysTemplate)
        case .mypage:
            return UIImage(named: "icon_mypage_active")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .cs:
            return UIImage(named: "icon_cs")?.withRenderingMode(.alwaysTemplate)
        case .develop:
            return UIImage(named: "icon_develop")?.withRenderingMode(.alwaysTemplate)
        case .favorite:
            return UIImage(named: "icon_favorite")?.withRenderingMode(.alwaysTemplate)
        case .mypage:
            return UIImage(named: "icon_mypage")?.withRenderingMode(.alwaysTemplate)
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
