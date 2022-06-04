//
//  AddSheetViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa

final class AddSheetViewController: BaseViewController, View {
    
    // MARK: properties
    typealias Reactor = AddSheetReactor
    private var category: Category
    let questionPlaceHolder = "질문을 작성해주세요"
    let answerPlaceHolder = "답변을 작성해주세요"
    
    // MARK: UI
    private let closeBtn: UIButton = {
        var btn = UIButton(type: .custom)
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: 30, height: 30)
        )
        btn.setImage(UIImage(named: "btn_close"), for: .normal)
        return btn
    }()
    
    private let saveBtn: UIButton = {
        var btn = UIButton()
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: 30, height: 30)
        )
        btn.setTitle("완료", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return btn
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        category: Category
    ) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        textFieldDelegate()
    }
    
    // MARK: methods
    private func setupUI() {
        // viewcontroller
        self.view.backgroundColor = .white
        self.navigationItem.title = "족보 쓰기"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
        self.addNavigationLineView()
        // questionTitle
        self.questionTitleTextView.text = questionPlaceHolder
        self.questionTitleTextView.textColor = .placeholderText
        self.questionTitleTextView.isEditable = true
        self.addQuestionTitleTextView()
        // TitleContentdivider
        self.addTitleContentdividerView()
        // AnswerContent
        self.answerContentTextView.text = answerPlaceHolder
        self.answerContentTextView.textColor = .placeholderText
        self.answerContentTextView.isEditable = true
        self.addAnswerContentTextView()
    }
}

// MARK: Reactor Bind
extension AddSheetViewController {
    func bind(reactor: AddSheetReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AddSheetReactor) {
        
        closeBtn.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        
        saveBtn.rx.tap
            .subscribe { [unowned self] _ in
            
            }.disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: AddSheetReactor) {
        
    }
}

// MARK: TextField Delegate
extension AddSheetViewController {
    func textFieldDelegate() {
        questionTitleTextView.rx.didBeginEditing
            .subscribe { [unowned self] _ in
                guard questionTitleTextView.textColor == .placeholderText else { return }
                questionTitleTextView.textColor = .label
                questionTitleTextView.text = nil
            }.disposed(by: self.disposeBag)
        
        questionTitleTextView.rx.didEndEditing
            .subscribe { [unowned self] _ in
                if questionTitleTextView.text.isEmpty {
                    questionTitleTextView.text = questionPlaceHolder
                    questionTitleTextView.textColor = .placeholderText
                }
            }.disposed(by: self.disposeBag)
        
        answerContentTextView.rx.didBeginEditing
            .subscribe { [unowned self] _ in
                guard answerContentTextView.textColor == .placeholderText else { return }
                answerContentTextView.textColor = .darkGray
                answerContentTextView.text = nil
            }.disposed(by: self.disposeBag)
        
        answerContentTextView.rx.didEndEditing
            .subscribe { [unowned self] _ in
                if answerContentTextView.text.isEmpty {
                    answerContentTextView.text = answerPlaceHolder
                    answerContentTextView.textColor = .placeholderText
                }
            }.disposed(by: self.disposeBag)
    }
}
