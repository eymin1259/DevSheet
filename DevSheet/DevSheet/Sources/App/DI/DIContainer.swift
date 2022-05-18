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
        registerViewController()
    }
    
    private func registerService() {
        register(FirebaseService.self) { _ in
            FirebaseServiceImpl()
        }
    }
    
    private func registerRepository() {
        register(SplashRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let repo = SplashRepositoryImpl(firebaseService: firebase)
            return repo
        }
    }
    
    private func registerUseCase() {
        register(SplashUseCase.self) { r in
            let repo = r.resolve(SplashRepository.self)!
            let useCase = SplashUseCaseImpl(repository: repo)
            return useCase
        }
    }
    
    private func registerReactor() {
        register(SplashReactor.self) { r in
            let useCase = r.resolve(SplashUseCase.self)!
            let reactor = SplashReactor(splashUseCase: useCase)
            return reactor
        }
    }
    
    private func registerViewController() {
        register(SplashViewController.self) { r in
            let reactor = r.resolve(SplashReactor.self)!
            let vc = SplashViewController(reactor: reactor)
            return vc
        }
    }
}
