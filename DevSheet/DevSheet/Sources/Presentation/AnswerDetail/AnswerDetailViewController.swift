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

final class AnswerDetailViewController: BaseViewController, View {
    
    // MARK: properties
    typealias Reactor = AnswerDetailReactor
    private var question: Question
    
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
        
        // shadow
        self.view.addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalToSuperview()
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
        
    }
}
