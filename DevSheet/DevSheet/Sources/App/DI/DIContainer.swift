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
    
    private func registerViewController() {
        register(SplashViewController.self) { r in
            let reactor = r.resolve(SplashReactor.self)!
            let vc = SplashViewController(reactor: reactor)
            return vc
        }
    }
}
