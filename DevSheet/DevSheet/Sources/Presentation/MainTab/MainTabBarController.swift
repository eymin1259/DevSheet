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
        beaverLog.debug("MainTabBarController  viewDidLoad")
        
        setup()
        bind()
    }
    
    // MARK: methods
    func setup() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemGray6
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2.0
        
    }
}

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
                beaverLog.debug("MainTabBarController  setViewControllers", context: tabItems)
                self.setViewControllers(viewControllers, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
