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
    private var editSheetFactory: (SheetEditMode, String, Question?, String) -> UIViewController
    
    // MARK: UI
    private let dividerView: UIView = {
        var divider = UIView()
        divider.backgroundColor = .systemGray5
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private let menuBtn: UIButton = {
        var btn = UIButton()
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: 60, height: 30)
        )
        btn.setTitle("메뉴", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        return btn
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        editSheetFactory: @escaping (SheetEditMode, String, Question?, String) -> UIViewController
    ) {
        self.editSheetFactory = editSheetFactory
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
        self.navigationItem.title = "족보"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuBtn)
        self.addNavigationLineView()
        // questionTitle
        self.questionTitleTextView.text = self.reactor?.initialState.question.title
        self.addQuestionTitleTextView()
        // TitleContentdivider
        self.addTitleContentdividerView()
        // AnswerContent
        self.addAnswerContentTextView()
    }
    
    func createActions() -> [UIAlertAction] {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            self?.presentEditSheet()
        }
        let addFavoriteAction = UIAlertAction(title: "즐겨찾기 추가", style: .default) { [weak self] _ in
            self?.reactor?.action.onNext(.addFavorite)
        }
        let removeFavoriteAction = UIAlertAction(title: "즐겨찾기 삭제", style: .default) { [weak self] _ in
            self?.reactor?.action.onNext(.removeFavorite)
        }
        if let currentTab = navigationController?.tabBarController?.selectedIndex,
           currentTab == MainTab.favorite.rawValue {
            return [cancelAction, editAction, removeFavoriteAction]
        }
        return [cancelAction, editAction, addFavoriteAction]
    }
    
    func presentEditSheet() {
        guard let reactor = self.reactor else { return }
        let editSheetVC = self.editSheetFactory(
            SheetEditMode.UPDATE,
            reactor.currentState.category.id,
            reactor.currentState.question,
            self.answerContentTextView.text
        )
        self.present(editSheetVC, animated: true, completion: nil)
    }
}

// MARK: Reactor Bind
extension AnswerDetailViewController {
    func bind(reactor: AnswerDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AnswerDetailReactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        menuBtn.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let actions = self.createActions()
                self.showActionSheet(title: nil, message: nil, actions: actions)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: AnswerDetailReactor) {
        reactor.state
            .map { $0.latestAnswer }
            .filterNil()
            .subscribe(onNext: { [weak self] answer in
                self?.answerContentTextView.text = answer.content
                if answer.title.isNotEmpty {
                    self?.questionTitleTextView.text = answer.title
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingHud()
                } else {
                    self?.hideLoadingHud()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.addFavoriteResult }
            .filterNil()
            .subscribe(onNext: { [weak self] result in
                if result == true {
                    self?.showshowSucceedHud(message: "추가되었습니다.", completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.removeFavoriteResult }
            .filterNil()
            .subscribe(onNext: { [weak self] result in
                if result == true {
                    self?.showshowSucceedHud(message: "삭제되었습니다.", completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            })
            .disposed(by: disposeBag)
    }
}
