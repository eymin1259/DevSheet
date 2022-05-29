//
//  QuestionListCell.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import UIKit
import SnapKit

class QuestionListCell: UITableViewCell {
    
    // MARK: properties
    static let ID = "QuestionListCell"
    
    // MARK: life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    func setupUI() {
      
    }
}
