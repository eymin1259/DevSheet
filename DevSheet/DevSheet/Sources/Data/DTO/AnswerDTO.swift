//
//  AnswerDTO.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase
import RealmSwift

class AnswerDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var questionId: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var createdBy: String
    @Persisted var timeStamp: String
    @Persisted var deleted: Bool
    
    convenience init(id: String, dictionary: [String: Any]) {
        self.init()
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
