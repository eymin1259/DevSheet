//
//  QuestionDTO.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import Firebase
import RealmSwift

class QuestionDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var categoryId: String
    @Persisted var timeStamp: String
    @Persisted var deleted: Bool
    
    convenience init(id: String, dictionary: [String: Any]) {
        self.init()
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
