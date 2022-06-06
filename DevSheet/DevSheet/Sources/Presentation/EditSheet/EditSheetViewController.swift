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
    private var editMode: SheetEditMode
    private var categoryId: String
    private var question: Question?
    private var defaultAnswerText: String?
    
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
        editMode: SheetEditMode,
        categoryId: String,
        question: Question?,
        defaultAnswerText: String?
    ) {
        self.editMode = editMode
        self.categoryId = categoryId
        self.question = question
        self.defaultAnswerText = defaultAnswerText
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
        self.questionTitleTextView.text = question?.title ??  SheetEditMode.ADD.defaultQuestoin
        self.questionTitleTextView.textColor = .placeholderText
        self.questionTitleTextView.isEditable = true
        self.addQuestionTitleTextView()
        // TitleContentdivider
        self.addTitleContentdividerView()
        // AnswerContent
        self.answerContentTextView.text = defaultAnswerText
        self.answerContentTextView.textColor = .placeholderText
        self.answerContentTextView.isEditable = true
        self.answerContentTextView.becomeFirstResponder()
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
                    editMode,
                    categoryId,
                    question,
                    defaultAnswerText
                )
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        closeBtn.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        
        questionTitleTextView.rx.didChange
            .map { [unowned self] _ in
                Reactor.Action.inputQuestion(questionTitleTextView.text)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        answerContentTextView.rx.didChange
            .map { [unowned self] _ in
                Reactor.Action.inputAnswer(answerContentTextView.text)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        saveBtn.rx.tap
            .map { _ in Reactor.Action.tapSaveBtn }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: EditSheetReactor) {
        reactor.state
            .map { $0.questionText }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] question in
                self?.questionTitleTextView.textColor = .label
                self?.questionTitleTextView.text = question
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.answerText }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] answer in
                self?.answerContentTextView.textColor = .darkGray
                self?.answerContentTextView.text = answer
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingHud()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.saveResult }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] result in
                if result == true {
                    self?.showshowSucceedHud(message: "저장 완료") {
                        self?.dismiss(animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] message in
                self?.hideLoadingHud()
                self?.showErrorToast(message: message)
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
                    questionTitleTextView.text = question?.title ??  SheetEditMode.ADD.defaultQuestoin
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
                    answerContentTextView.text = defaultAnswerText
                    answerContentTextView.textColor = .placeholderText
                }
            }.disposed(by: self.disposeBag)
    }
}
