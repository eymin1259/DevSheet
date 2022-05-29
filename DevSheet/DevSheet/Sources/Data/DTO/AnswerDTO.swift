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
    var version: Int
    var createdBy: String
    var timeStamp: Timestamp
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.questionId = dictionary["questionId"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.version = dictionary["version"] as? Int ?? -1
        self.createdBy = dictionary["createdBy"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Answer {
        return .init(
            id: id,
            questionId: questionId,
            title: title,
            content: content,
            version: version,
            createdBy: createdBy,
            createdAt: timeStamp.dateValue().getToday(),
            deleted: deleted
        )
    }
}
