//
//  EditSheetViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa
import RxViewController
import RxOptional

final class EditSheetViewController: BaseViewController, View {
    
    // MARK: properties
    typealias Reactor = EditSheetReactor
    private var category: Category
    private var editMode: EditMode
    private var defaultQuestoin: String
    private var defaultAnswer: String
    
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
        category: Category,
        editMode: EditMode,
        defaultQuestoin: String,
        defaultAnswer: String
    ) {
        self.category = category
        self.editMode = editMode
        self.defaultQuestoin = defaultQuestoin
        self.defaultAnswer = defaultAnswer
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
        self.navigationItem.title = editMode.navigationTitleText
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
        self.addNavigationLineView()
        // questionTitle
        self.questionTitleTextView.textColor = .placeholderText
        self.questionTitleTextView.isEditable = true
        self.addQuestionTitleTextView()
        // TitleContentdivider
        self.addTitleContentdividerView()
        // AnswerContent
        self.answerContentTextView.textColor = .placeholderText
        self.answerContentTextView.isEditable = true
        self.addAnswerContentTextView()
    }
}

// MARK: Reactor Bind
extension EditSheetViewController {
    func bind(reactor: EditSheetReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: EditSheetReactor) {
        
        self.rx.viewDidLoad
            .map { [unowned self] _ in
                Reactor.Action.viewDidLoad(
                    category,
                    editMode,
                    defaultQuestoin,
                    defaultAnswer
                )
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        closeBtn.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        
        Observable
            .combineLatest(
                questionTitleTextView.rx.didChange,
                answerContentTextView.rx.didChange
            )
            .map { [unowned self] _ in
                Reactor.Action.inputText(
                    questionTitleTextView.text,
                    answerContentTextView.text
                )
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        saveBtn.rx.tap
            .subscribe { [unowned self] _ in
            
            }.disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: EditSheetReactor) {
        reactor.state
            .map { $0.question }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] question in
                self?.questionTitleTextView.text = question
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.answer }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] answer in
                self?.answerContentTextView.text = answer
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextField Delegate
extension EditSheetViewController {
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
                    questionTitleTextView.text = defaultQuestoin
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
                    answerContentTextView.text = defaultAnswer
                    answerContentTextView.textColor = .placeholderText
                }
            }.disposed(by: self.disposeBag)
    }
}
