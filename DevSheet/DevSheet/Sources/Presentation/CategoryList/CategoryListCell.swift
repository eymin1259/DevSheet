//
//  CategoryListCell.swift
//  DevSheet
//
//  Created by yongmin lee on 5/24/22.
//

import UIKit
import SnapKit

final class CategoryListCell: BaseTableViewCell {
    
    // MARK: properties
    static let ID = "CategoryListCell"
    
    // MARK: UI
    private let categoryNameLabel: UILabel = {
       var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    override func setupUI() {
        super.setupUI()
        // categoryNameLabel
        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(with data: Category) {
        categoryNameLabel.text = data.name
    }
}
