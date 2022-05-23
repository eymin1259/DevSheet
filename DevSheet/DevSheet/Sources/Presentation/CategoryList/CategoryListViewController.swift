//
//  CategoryListViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import UIKit
import ReactorKit
import RxViewController
import RxOptional

final class CategoryListViewController: BaseViewController, View {

    // MARK: properties
    typealias Reactor = CategoryListReactor
    var categoryGroup: MainTab?
    
    // MARK: UI
    
    // MARK: initialize
    init(reactor: Reactor) {
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
            .subscribe(onNext: { list in
                beaverLog.debug("category list -> ", context: list)
            }).disposed(by: self.disposeBag)
    }
}
