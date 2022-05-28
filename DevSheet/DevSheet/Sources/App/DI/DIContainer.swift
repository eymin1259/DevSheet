//
//  DIContainer.swift
//  DevSheet
//
//  Created by yongmin lee on 5/16/22.
//

import Foundation
import Swinject
import UIKit

extension Container {
    
    func registerDependencies() {
        registerService()
        registerRepository()
        registerUseCase()
        registerReactor()
        registerViewModel()
        registerViewController()
    }
    
    private func registerService() {
        register(FirebaseService.self) { _ in
            return FirebaseServiceImpl()
        }
    }
    
    private func registerRepository() {
        register(VersionRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let repo = VersionRepositoryImpl(firebaseService: firebase)
            return repo
        }
        
        register(CategoryRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let repo = CategoryRepositoryImpl(firebaseService: firebase)
            return repo
        }.inObjectScope(.transient)
    }
    
    private func registerUseCase() {
        register(VersionUseCase.self) { r in
            let repo = r.resolve(VersionRepository.self)!
            let useCase = VersionUseCaseImpl(versionRepository: repo)
            return useCase
        }
        
        register(CategoryUseCase.self) { r in
            let repo = r.resolve(CategoryRepository.self)!
            let useCase = CategoryUseCaseImpl(categoryRepository: repo)
            return useCase
        }.inObjectScope(.transient)
    }
    
    private func registerReactor() {
        register(SplashReactor.self) { r in
            let useCase = r.resolve(VersionUseCase.self)!
            let reactor = SplashReactor(versionUseCase: useCase)
            return reactor
        }
        
        register(CategoryListReactor.self) { r in
            let useCase = r.resolve(CategoryUseCase.self)!
            let reactor = CategoryListReactor(categoryUseCase: useCase)
            return reactor
        }.inObjectScope(.transient)
    }
    
    private func registerViewModel() {
        register(MainTabViewModel.self) { _ in
            return MainTabViewModel()
        }
    }
    
    private func registerViewController() {
        register(SplashViewController.self) { [unowned self] r in
            let reactor = r.resolve(SplashReactor.self)!
            let vc = SplashViewController(
                reactor: reactor,
                mainTabFactory: self.mainTabFactory
            )
            return vc
        }
        
        register(CategoryListViewController.self) { (r: Resolver, mainTab: MainTab) in
            let reactor = r.resolve(CategoryListReactor.self)!
            let vc = CategoryListViewController(reactor: reactor, mainTab: mainTab)
            return vc
        }.inObjectScope(.transient)
        
        register(MypageViewController.self) { _ in
            let vc = MypageViewController()
            return vc
        }
        
        register(MainTabBarController.self) { [unowned self] r in
            let viewModel = r.resolve(MainTabViewModel.self)!
            let vc =  MainTabBarController(
                viewModel: viewModel,
                viewControllerFactory: self.mainTabBarControllerFactory(mainTab:)
            )
            return vc
        }
    }
    
    // MARK: factories
    private func mainTabFactory() -> UIViewController {
        let mainTabVC = resolve(MainTabBarController.self)!
        mainTabVC.modalPresentationStyle = .fullScreen
        mainTabVC.modalTransitionStyle = .crossDissolve
        return mainTabVC
    }
    
    private func  mainTabBarControllerFactory(mainTab: MainTab) -> UIViewController {
        let createdVC: UIViewController
        switch mainTab {
        case .cs:
            let rootVC = resolve(CategoryListViewController.self, argument: mainTab)!
            createdVC = UINavigationController(rootViewController: rootVC)
        case .develop:
            let rootVC = resolve(CategoryListViewController.self, argument: mainTab)!
            createdVC = UINavigationController(rootViewController: rootVC)
        case .favorite:
            let rootVC = resolve(CategoryListViewController.self, argument: mainTab)!
            createdVC = UINavigationController(rootViewController: rootVC)
        case .mypage:
            createdVC = resolve(MypageViewController.self)!
        }
        createdVC.tabBarItem = mainTab.getTabBarItem()
        return createdVC
    }
}
