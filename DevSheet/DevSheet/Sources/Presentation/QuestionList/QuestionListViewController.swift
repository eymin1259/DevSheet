//
//  QuestionListViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import ReactorKit
import SnapKit
import RxViewController
import RxOptional
import RxDataSources
import UIKit

final class QuestionListViewController: BaseViewController, View {    
    
    // MARK: properties
    typealias Reactor = QuestionListReactor
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<QuestionListSection>
    private var answerDetailFactory: (Category, Question) -> UIViewController
    private var editSheetFactory: (SheetEditMode, String, Question?, String) -> UIViewController
    
    // MARK: UI
    private let questionTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension // dynamic height
        tableView.estimatedRowHeight = 50.0
        tableView.register(
            QuestionListCell.self,
            forCellReuseIdentifier: QuestionListCell.ID
        )
        return tableView
    }()
    
    private let addNewSheetBtn: UIButton = {
        var btn = UIButton()
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: 30, height: 30)
        )
        btn.setTitle("추가", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return btn
    }()
    
    private let pickRandomSheetBtn: UIButton = {
        var btn = UIButton()
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: 30, height: 30)
        )
        btn.setTitle("랜덤", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return btn
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        answerDetailFactory: @escaping (Category, Question) -> UIViewController,
        editSheetFactory: @escaping (SheetEditMode, String, Question?, String) -> UIViewController
    ) {
        self.tableViewDataSource = Self.tableViewDataSourceFactory()
        self.answerDetailFactory = answerDetailFactory
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
        self.navigationItem.title = self.reactor?.initialState.category.name
        navigationItem.backBarButtonItem = backBarBtn
        self.navigationItem.rightBarButtonItem = createUIBarButtonItem()
        // tablewView
        self.view.addSubview(questionTableView)
        questionTableView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        // navigationLineView
        self.addNavigationLineView()
    }
    
    func presentEditSheet() {
        guard let categoryId = self.reactor?.currentState.category.id else { return }
        let editSheetVC = self.editSheetFactory(
            SheetEditMode.ADD,
            categoryId,
            nil,
            SheetEditMode.ADD.defaultAnswer
        )
        self.present(editSheetVC, animated: true, completion: nil)
    }
    
    // MARK: Factories
    private static func tableViewDataSourceFactory()
    -> RxTableViewSectionedReloadDataSource<QuestionListSection> {
        return .init { _, tableView, index, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: QuestionListCell.ID,
                for: index
            )
            if let questionListCell = cell as? QuestionListCell {
                questionListCell.bind(with: item)
            }
            return cell
        }
    }
    
    private func createUIBarButtonItem() -> UIBarButtonItem {
        if navigationController?.tabBarController?.selectedIndex == MainTab.favorite.rawValue {
            return UIBarButtonItem(customView: pickRandomSheetBtn)
        } else {
            return UIBarButtonItem(customView: addNewSheetBtn)
        }
    }
}

// MARK: Reactor Bind
extension QuestionListViewController {
    func bind(reactor: QuestionListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: QuestionListReactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        addNewSheetBtn.rx.tap
            .subscribe {  [weak self] _ in
                guard let self = self else {return}
                self.presentEditSheet()
            }.disposed(by: self.disposeBag)
        
        pickRandomSheetBtn.rx.tap
            .map { _ in Reactor.Action.tapRandomBtn }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable
            .zip(
                questionTableView.rx.itemSelected,
                questionTableView.rx.modelSelected(Question.self)
            )
            .bind { [weak self] indexPath, model in
                guard let self = self else {return}
                guard let category = self.reactor?.currentState.category else {return}
                self.questionTableView.deselectRow(at: indexPath, animated: true)
                let answerVC = self.answerDetailFactory(category, model)
                self.navigationController?.pushViewController(answerVC, animated: true)
            }
            .disposed(by: disposeBag)

    }
    
    private func bindState(reactor: QuestionListReactor) {
        reactor.state
            .map { $0.questionSections }
            .bind(to: questionTableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.randomQuestion }
            .filterNil()
            .subscribe(onNext: { [weak self] question in
                guard let self = self else {return}
                guard let category = self.reactor?.currentState.category else {return}
                let answerVC = self.answerDetailFactory(category, question)
                self.navigationController?.pushViewController(answerVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
