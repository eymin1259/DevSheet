//
//  Answer.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation

struct Answer {
    var id: String
    var questionId: String
    var title: String
    var content: String
    var version: Int
    var createdBy: String
    var createdAt: String
    var deleted: Bool
    
    static func getEmptyAnswer() -> Answer {
        return .init(
            id: "",
            questionId: "",
            title: "",
            content: "답변이 아직 작성되지 않았습니다",
            version: -1,
            createdBy: "",
            createdAt: Date().getToday(),
            deleted: false
        )
    }
}
