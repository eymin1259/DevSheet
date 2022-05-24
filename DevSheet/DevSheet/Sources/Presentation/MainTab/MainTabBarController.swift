//
//  MainTabBarController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/20/22.
//

import Foundation
import UIKit
import RxSwift

final class MainTabBarController: UITabBarController {
    
    // MARK: properties
    private var disposeBag: DisposeBag = .init()
    private let viewModel: MainTabViewModel
    private let viewControllerFactory: (MainTab) -> UIViewController
    
    // MARK: initialize
    init(
        viewModel: MainTabViewModel,
        viewControllerFactory: @escaping (MainTab) -> UIViewController
    ) {
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    // MARK: methods
    func setup() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.layer.makeShadow()
    }
}

// MARK: ViewModel Bind
extension MainTabBarController {
    func bind() {
        viewModel.tabItems
            .distinctUntilChanged()
            .subscribe( onNext: { [weak self] tabItems in
                guard let self = self else { return }
                let viewControllers = tabItems.map { tabItem -> UIViewController in
                    let viewController = self.viewControllerFactory(tabItem)
                    return viewController
                }
                self.setViewControllers(viewControllers, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
