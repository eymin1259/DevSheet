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
    private var addSheetFactory: (Category) -> UIViewController
    
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
    
    private let addSheetBtn: UIButton = {
        var btn = UIButton()
        let img = UIImage(named: "icon_write")
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .systemOrange
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        category: Category,
        answerDetailFactory: @escaping (Question) -> UIViewController,
        addSheetFactory: @escaping (Category) -> UIViewController
    ) {
        self.category = category
        self.tableViewDataSource = Self.tableViewDataSourceFactory()
        self.answerDetailFactory = answerDetailFactory
        self.addSheetFactory = addSheetFactory
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
        
        // tablewView
        self.view.addSubview(questionTableView)
        questionTableView.snp.makeConstraints {
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
            $0.top.equalToSuperview()
        }
        
        // addSheetBtn
        self.view.addSubview(addSheetBtn)
        addSheetBtn.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(60)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    private func showAddSheetBtn() {
        let asyncDuration: DispatchTimeInterval = .milliseconds(500)
        DispatchQueue.main.asyncAfter(
            deadline: .now() + asyncDuration
        ) { [weak self] in
            guard let self = self else { return }
            let animateDutaion: TimeInterval = 0.5
            self.addSheetBtn.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(10)
            }
            UIView.animate(withDuration: animateDutaion) {
                self.view.layoutIfNeeded()
            }
        }
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
        self.rx.viewDidLoad
            .subscribe { [weak self] _ in
                self?.showAddSheetBtn()
            }.disposed(by: self.disposeBag)
        
        self.rx.viewDidAppear
            .map { [unowned self] _ in
                Reactor.Action.viewDidAppear(self.category.id)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        addSheetBtn.rx
            .tap
            .subscribe {  [weak self] _ in
                guard let self = self else {return}
                let addSheetVC = self.addSheetFactory(self.category)
                self.present(addSheetVC, animated: true, completion: nil)
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
