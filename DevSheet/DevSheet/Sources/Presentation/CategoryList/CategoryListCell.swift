//
//  CategoryListCell.swift
//  DevSheet
//
//  Created by yongmin lee on 5/24/22.
//

import UIKit
import SnapKit

class CategoryListCell: UITableViewCell {
    
    // MARK: properties
    static let ID = "CategoryListCell"
    
    // MARK: UI
    private let categoryNameLabel: UILabel = {
       var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let nextBtn: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        let img = UIImage(named: "btn_next")
        iv.image = img
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
    func setupUI() {
        
        // TableViewCell
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // categoryNameLabel
        addSubview(categoryNameLabel)
        categoryNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        // nextBtn
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints {
            $0.width.equalTo(6)
            $0.height.equalTo(12)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(with data: Category) {
        categoryNameLabel.text = data.name
    }
}
