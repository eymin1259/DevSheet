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
    var timeStamp: String
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.categoryId = dictionary["categoryId"] as? String ?? ""
        let timestamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.timeStamp = timestamp.dateValue().getToday()
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Question {
        return .init(
            id: id,
            title: title,
            categoryId: categoryId,
            createdAt: timeStamp,
            deleted: deleted
        )
    }
}
