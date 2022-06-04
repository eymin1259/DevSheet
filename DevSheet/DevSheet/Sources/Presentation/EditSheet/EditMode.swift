//
//  EditMode.swift
//  DevSheet
//
//  Created by yongmin lee on 6/4/22.
//

import Foundation

enum EditMode {
    case ADD
    case UPDATE
}

extension EditMode {
    var navigationTitleText: String {
        switch self {
        case .ADD: return "새로운 족보 추가"
        case .UPDATE: return "족보 수정하기"
        }
    }
    
    var defaultQuestoin: String {
        switch self {
        case .ADD: return "질문을 작성해주세요"
        case .UPDATE: return "질문이 아직 작성되지 않았습니다"
        }
    }
    
    var defaultAnswer: String {
        switch self {
        case .ADD: return "답변을 작성해주세요"
        case .UPDATE: return "답변이 아직 작성되지 않았습니다"
        }
    }
}
