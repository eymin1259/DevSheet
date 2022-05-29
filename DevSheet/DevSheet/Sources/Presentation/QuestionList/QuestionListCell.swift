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
    
    // MARK: UI
    private let questionTitleLbl: UILabel = {
       var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
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
        // questionTitleLbl
        contentView.addSubview(questionTitleLbl)
        questionTitleLbl.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(46)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        // nextBtn
        contentView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints {
            $0.width.equalTo(6)
            $0.height.equalTo(12)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(with data: Question) {
        questionTitleLbl.text = data.title
    }
}
