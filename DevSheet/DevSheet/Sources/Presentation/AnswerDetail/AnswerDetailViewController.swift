//
//  AnswerDetailViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import UIKit
import ReactorKit
import SnapKit
import RxViewController
import RxOptional

final class AnswerDetailViewController: BaseViewController, View {
    
    // MARK: properties
    typealias Reactor = AnswerDetailReactor
    private var question: Question
    
    // MARK: UI
    private lazy var titleTextView: UITextView = {
        var textView = UITextView()
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.font = .boldSystemFont(ofSize: 20)
        textView.isUserInteractionEnabled = false
        textView.text = self.question.title
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let dividerView: UIView = {
        var divider = UIView()
        divider.backgroundColor = .systemGray5
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private var contentTextView: UITextView = {
        var textView = UITextView()
        textView.autocorrectionType = .no
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .darkGray
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.text = ""
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        question: Question
    ) {
        self.question = question
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
    }
    
    // MARK: methods
    private func setupUI() {
        // viewcontroller
        self.view.backgroundColor = .white
        
        // navigationLineView
        self.addNavigationLineView()
        
        self.view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(10)
        }
        
        self.view.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        self.view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(3)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
        }
    }
}

// MARK: Reactor Bind
extension AnswerDetailViewController {
    func bind(reactor: AnswerDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AnswerDetailReactor) {
        self.rx.viewDidLoad
            .map { [unowned self] _ in
                Reactor.Action.viewDidLoad(self.question.id)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: AnswerDetailReactor) {
        reactor.state
            .map { $0.latestAnswer }
            .filterNil()
            .subscribe(onNext: { [weak self] answer in
                self?.contentTextView.text = answer.content
            })
            .disposed(by: disposeBag)
    }
}
