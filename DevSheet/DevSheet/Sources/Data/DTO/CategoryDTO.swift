//
//  CategoryDTO.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import Foundation
import Firebase

struct CategoryDTO {
    var id: String
    var name: String
    var groupId: Int
    var imageUrl: String
    var orderNumber: Int
    var timeStamp: String
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.groupId = dictionary["groupId"] as? Int ?? -1
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.orderNumber = dictionary["orderNumber"] as? Int ?? -1
        let timestamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.timeStamp = timestamp.dateValue().getToday()
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Category {
        return .init(
            id: id,
            name: name,
            groupId: groupId,
            imageUrl: imageUrl,
            orderNumber: orderNumber,
            createdAt: timeStamp,
            deleted: deleted
        )
    }
}
