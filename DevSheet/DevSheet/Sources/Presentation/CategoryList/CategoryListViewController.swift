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
    var categoryGroup: MainTab?
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<CategoryListSection>
    
    // MARK: UI
    private let shadowView: UIView = {
        var shadow = UIView()
        shadow.backgroundColor = .white
        shadow.layer.makeShadow()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        return shadow
    }()
    
    private let categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CategoryListCell.self,
            forCellReuseIdentifier: CategoryListCell.ID
        )
        return tableView
    }()
    
    let refreshControl = UIRefreshControl()
    
    // MARK: initialize
    init(reactor: Reactor) {
        tableViewDataSource = Self.dataSourceFactory()
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
        self.navigationItem.title = self.categoryGroup?.description ?? "카테고리"
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        
        // tablewView
        self.view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }

        // shadow
        self.view.addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
    }
    
    // MARK: Factories
    private static func dataSourceFactory()
    -> RxTableViewSectionedReloadDataSource<CategoryListSection> {
        return .init { _, tableView, index, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryListCell.ID,
                for: index
            )
            if let categoryListCell = cell as? CategoryListCell {
                categoryListCell.configure(with: item)
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
            .map { [weak self] _ in
                return Reactor.Action.viewDidAppear(self?.categoryGroup)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: CategoryListReactor) {
        
        reactor.state
            .map { $0.categoryList }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { list in
                beaverLog.debug("category list -> ", context: list)
            }).disposed(by: self.disposeBag)
    
    }
}
