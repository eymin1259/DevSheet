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
    private var category: Category
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<QuestionListSection>
    private var answerDetailFactory: (Question) -> UIViewController
    private var editSheetFactory: (SheetEditMode, String, Question?, String?) -> UIViewController
    
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
    
    // MARK: initialize
    init(
        reactor: Reactor,
        category: Category,
        answerDetailFactory: @escaping (Question) -> UIViewController,
        editSheetFactory: @escaping (SheetEditMode, String, Question?, String?) -> UIViewController
    ) {
        self.category = category
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
        self.navigationItem.title = self.category.name
        navigationItem.backBarButtonItem = backBarBtn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addNewSheetBtn)
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
}

// MARK: Reactor Bind
extension QuestionListViewController {
    func bind(reactor: QuestionListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: QuestionListReactor) {
        self.rx.viewDidAppear
            .map { [unowned self] _ in
                Reactor.Action.viewDidAppear(self.category.id)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        addNewSheetBtn.rx.tap
            .subscribe {  [weak self] _ in
                guard let self = self else {return}
                let editSheetVC = self.editSheetFactory(
                    SheetEditMode.ADD,
                    self.category.id,
                    nil,
                    SheetEditMode.ADD.defaultAnswer
                )
                self.present(editSheetVC, animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        
        Observable
            .zip(
                questionTableView.rx.itemSelected,
                questionTableView.rx.modelSelected(Question.self)
            )
            .bind { [weak self] indexPath, model in
                guard let self = self else {return}
                self.questionTableView.deselectRow(at: indexPath, animated: true)
                let answerVC = self.answerDetailFactory(model)
                self.navigationController?.pushViewController(answerVC, animated: true)
            }
            .disposed(by: disposeBag)

    }
    
    private func bindState(reactor: QuestionListReactor) {
        reactor.state
            .map { $0.questionSections }
            .bind(to: questionTableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)        
    }
}
