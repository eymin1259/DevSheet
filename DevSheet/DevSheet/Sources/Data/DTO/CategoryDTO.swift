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
    var group: Int
    var imageUrl: String
    var order: Int
    var timeStamp: Timestamp
    var deleted: Bool
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.group = dictionary["group"] as? Int ?? -1
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.order = dictionary["order"] as? Int ?? -1
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.deleted = dictionary["deleted"] as? Bool ?? true
    }
    
    func toDomain() -> Category {
        return .init(
            id: id,
            name: name,
            group: group,
            imageUrl: imageUrl,
            deleted: deleted
        )
    }
}
