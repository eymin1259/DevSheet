//
//  SheetError.swift
//  DevSheet
//
//  Created by yongmin lee on 6/5/22.
//

import Foundation

enum SheetError: Error {
    case unknown
    case server
    case emptyQuestion
    case emptyAnswer
    case saveFail
}

extension SheetError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown: return "알 수 없는 오류"
        case .server: return "서버 오류"
        case .emptyQuestion: return "질문을 작성해주세요."
        case .emptyAnswer: return "답변을 작성해주세요."
        case .saveFail: return "저장 실패"
        }
    }
}
