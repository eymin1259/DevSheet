//
//  CategoryDTO.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import Firebase
import RealmSwift

class CategoryDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var group: Int
    @Persisted var imageUrl: String
    @Persisted var order: Int
    @Persisted var timeStamp: String
    @Persisted var deleted: Bool
    
    convenience init(id: String, dictionary: [String: Any]) {
        self.init()
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.group = dictionary["group"] as? Int ?? -1
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.order = dictionary["order"] as? Int ?? -1
        let timestamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.timeStamp = timestamp.dateValue().getToday()
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Category {
        return .init(
            id: id,
            name: name,
            group: group,
            imageUrl: imageUrl,
            order: order,
            createdAt: timeStamp,
            deleted: deleted
        )
    }
}
