//
//  BaseTableViewCell.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    // MARK: UI
    let nextBtn: UIImageView = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: method
    func setupUI() {
        backgroundColor = .white
        // nextBtn
        contentView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints {
            $0.width.equalTo(6)
            $0.height.equalTo(12)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
