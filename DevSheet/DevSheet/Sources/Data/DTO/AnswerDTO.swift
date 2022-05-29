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
    var content: String
    var createdBy: String
    var timeStamp: Timestamp
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.questionId = dictionary["questionId"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.createdBy = dictionary["createdBy"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Answer {
        return Answer(
            id: id,
            questionId: questionId,
            content: content,
            createdBy: createdBy,
            createdAt: timeStamp.dateValue(),
            deleted: deleted
        )
    }
}
