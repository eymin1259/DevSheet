//
//  QuestionListCell.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import UIKit
import SnapKit

final class QuestionListCell: BaseTableViewCell {
    
    // MARK: properties
    static let ID = "QuestionListCell"
    
    // MARK: UI
    private let questionTitleLbl: UILabel = {
       var lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
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
        // questionTitleLbl
        contentView.addSubview(questionTitleLbl)
        questionTitleLbl.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(46)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func bind(with data: Question) {
        questionTitleLbl.text = data.title
    }
}
