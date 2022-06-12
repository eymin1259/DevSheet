//
//  CategoryListViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxViewController
import RxOptional
import RxDataSources

final class CategoryListViewController: BaseViewController, View {

    // MARK: properties
    typealias Reactor = CategoryListReactor
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<CategoryListSection>
    private var questionListVCFactory: (MainTab, Category) -> UIViewController
    
    // MARK: UI
    private let categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension // dynamic height
        tableView.estimatedRowHeight = 50.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CategoryListCell.self,
            forCellReuseIdentifier: CategoryListCell.ID
        )
        return tableView
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        questionListVCFactory: @escaping (MainTab, Category) -> UIViewController
    ) {
        tableViewDataSource = Self.dataSourceFactory()
        self.questionListVCFactory = questionListVCFactory
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
        // ViewController
        self.view.backgroundColor = .systemGray6
        self.navigationItem.title = self.reactor?.initialState.categoryGroup.description
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backBarBtn
        // tablewView
        self.view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        // navigationLineView
        self.addNavigationLineView()
    }
    
    // MARK: Factory
    private static func dataSourceFactory()
    -> RxTableViewSectionedReloadDataSource<CategoryListSection> {
        return .init { _, tableView, index, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryListCell.ID,
                for: index
            )
            if let categoryListCell = cell as? CategoryListCell {
                categoryListCell.bind(with: item)
            }
            return cell
        }
    }
    
}

// MARK: Reactor Bind
extension CategoryListViewController {
    func bind(reactor: CategoryListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CategoryListReactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable
            .zip(
                categoryTableView.rx.itemSelected,
                categoryTableView.rx.modelSelected(Category.self)
            )
            .bind { [weak self] indexPath, model in
                guard let self = self else {return}
                guard let categoryGroup = self.reactor?.currentState.categoryGroup else {return}
                self.categoryTableView.deselectRow(at: indexPath, animated: true)
                let questionListVC = self.questionListVCFactory(categoryGroup, model)
                self.navigationController?.pushViewController(questionListVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: CategoryListReactor) {
        reactor.state
            .map { $0.categorySections }
            .bind(to: categoryTableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)
    }
}
