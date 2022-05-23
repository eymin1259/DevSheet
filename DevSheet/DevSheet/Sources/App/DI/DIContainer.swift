//
//  DIContainer.swift
//  DevSheet
//
//  Created by yongmin lee on 5/16/22.
//

import Foundation
import Swinject

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
    }
    
    private func registerUseCase() {
        register(VersionUseCase.self) { r in
            let repo = r.resolve(VersionRepository.self)!
            let useCase = VersionUseCaseImpl(versionRepository: repo)
            return useCase
        }
    }
    
    private func registerReactor() {
        register(SplashReactor.self) { r in
            let useCase = r.resolve(VersionUseCase.self)!
            let reactor = SplashReactor(versionUseCase: useCase)
            return reactor
        }
    }
    
    private func registerViewModel() {
        register(MainTabViewModel.self) { _ in
            return MainTabViewModel()
        }
    }
    
    private func registerViewController() {
        register(SplashViewController.self) { r in
            let reactor = r.resolve(SplashReactor.self)!
            let vc = SplashViewController(reactor: reactor)
            return vc
        }
        
        register(CategoryListViewController.self) { _ in
            let vc = CategoryListViewController()
            return vc
        }.inObjectScope(.transient)
        
        register(MypageViewController.self) { _ in
            let vc = MypageViewController()
            return vc
        }
        
        register(MainTabBarController.self) { r in
            let viewModel = r.resolve(MainTabViewModel.self)!
            let vc =  MainTabBarController(
                viewModel: viewModel,
                viewControllerFactory: { tab in
                    let createdVC: UIViewController
                    switch tab {
                    case .cs:
                        createdVC = r.resolve(CategoryListViewController.self)!
                    case .develop:
                        createdVC = r.resolve(CategoryListViewController.self)!
                    case .favorite:
                        createdVC = r.resolve(CategoryListViewController.self)!
                    case .mypage:
                        createdVC = r.resolve(MypageViewController.self)!
                    }
                    createdVC.tabBarItem = tab.getTabBarItem()
                    return createdVC
                }
            )
            return vc
        }
    }
}
