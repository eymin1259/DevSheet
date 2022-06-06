//
//  AnswerDTO.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase

struct AnswerDTO {
    var id: String
    var questionId: String
    var title: String
    var content: String
    var createdBy: String
    var timeStamp: String
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.questionId = dictionary["questionId"] as? String ?? ""
        self.title = dictionary["questionTitle"] as? String ?? ""
        self.content = dictionary["answerContent"] as? String ?? ""
        self.createdBy = dictionary["createdBy"] as? String ?? ""
        let timestamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.timeStamp = timestamp.dateValue().getToday()
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Answer {
        return .init(
            id: id,
            questionId: questionId,
            title: title,
            content: content,
            createdBy: createdBy,
            createdAt: timeStamp,
            deleted: deleted
        )
    }
}
