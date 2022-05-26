//
//  CategoryListCell.swift
//  DevSheet
//
//  Created by yongmin lee on 5/24/22.
//

import UIKit

class CategoryListCell: UITableViewCell {
    
    //MARK: properties
    static let ID = "CategoryListCell"
    
    // MARK: life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: Category) {
        print("debug : CategoryListCell configure -> \(data.name)")
    }
}
