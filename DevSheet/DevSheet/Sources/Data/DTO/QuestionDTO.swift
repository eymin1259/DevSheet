//
//  QuestionDTO.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase

struct QuestionDTO {
    var id: String
    var title: String
    var categoryId: String
    var timeStamp: Timestamp
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.categoryId = dictionary["categoryId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Question {
        return Question(
            id: id,
            title: title,
            categoryId: categoryId,
            createdAt: timeStamp.dateValue(),
            deleted: deleted
        )
    }
}
