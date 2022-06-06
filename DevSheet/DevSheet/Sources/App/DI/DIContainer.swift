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
        
        register(QuestionRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let repo = QuestionRepositoryImpl(firebaseService: firebase)
            return repo
        }.inObjectScope(.transient)
        
        register(AnswerRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let repo = AnswerRepositoryImpl(firebaseService: firebase)
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
        
        register(QuestionUseCase.self) { r in
            let repo = r.resolve(QuestionRepository.self)!
            let useCase = QuestionUseCaseImpl(questionRepository: repo)
            return useCase
        }.inObjectScope(.transient)
        
        register(AnswerUseCase.self) { r in
            let repo = r.resolve(AnswerRepository.self)!
            let useCase = AnswerUseCaseImpl(answerRepository: repo)
            return useCase
        }.inObjectScope(.transient)
        
        register(SheetUseCase.self) { r in
            let questionRepo = r.resolve(QuestionRepository.self)!
            let answerRepo = r.resolve(AnswerRepository.self)!
            let useCase = SheetUseCaseImpl(
                questionRepository: questionRepo,
                answerRepository: answerRepo
            )
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
        
        register(QuestionListReactor.self) { r in
            let useCase = r.resolve(QuestionUseCase.self)!
            let reactor = QuestionListReactor(questionUseCase: useCase)
            return reactor
        }.inObjectScope(.transient)
        
        register(AnswerDetailReactor.self) { r in
            let useCase = r.resolve(AnswerUseCase.self)!
            let reactor = AnswerDetailReactor(answerUseCase: useCase)
            return reactor
        }.inObjectScope(.transient)
        
        register(EditSheetReactor.self) { r in
            let usecase = r.resolve(SheetUseCase.self)!
            let reactor = EditSheetReactor(sheetUseCase: usecase)
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
        
        register(MainTabBarController.self) { [unowned self] r in
            let viewModel = r.resolve(MainTabViewModel.self)!
            let vc =  MainTabBarController(
                viewModel: viewModel,
                viewControllerFactory: self.mainTabBarControllerFactory(mainTab:)
            )
            return vc
        }
        
        register(
            CategoryListViewController.self
        ) { [unowned self] (r: Resolver, mainTab: MainTab) in
            let reactor = r.resolve(CategoryListReactor.self)!
            let vc = CategoryListViewController(
                reactor: reactor,
                mainTab: mainTab,
                viewControllerFactory: self.questionListViewControllerFactory(category:)
            )
            return vc
        }.inObjectScope(.transient)
        
        register(
            QuestionListViewController.self
        ) { [unowned self] (r: Resolver, category: Category) in
            let reactor = r.resolve(QuestionListReactor.self)!
            let vc = QuestionListViewController(
                reactor: reactor,
                category: category,
                answerDetailFactory: self.answerDetailViewControllerFactory(category:question:),
                editSheetFactory: self.editSheetViewControllerFactory(editMode:categoryId:question:answerText:)
            )
            return vc
        }.inObjectScope(.transient)
        
        register(AnswerDetailViewController.self) { [unowned self]  (r: Resolver, category: Category, question: Question) in
            let reactor = r.resolve(AnswerDetailReactor.self)!
            let vc = AnswerDetailViewController(
                reactor: reactor,
                category: category,
                question: question,
                editSheetFactory: self.editSheetViewControllerFactory(editMode:categoryId:question:answerText:)
            )
            return vc
        }.inObjectScope(.transient)
        
        register(EditSheetViewController.self) {
            (r: Resolver, editMode: SheetEditMode, categoryId: String, question: Question?, answerText: String?) in
            let reactor = r.resolve(EditSheetReactor.self)!
            let vc = EditSheetViewController(
                reactor: reactor,
                editMode: editMode,
                categoryId: categoryId,
                question: question,
                defaultAnswerText: answerText
            )
            return vc
        }.inObjectScope(.transient)
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
        }
        createdVC.tabBarItem = mainTab.getTabBarItem()
        return createdVC
    }
    
    private func questionListViewControllerFactory(category: Category) -> UIViewController {
        let questionVC = resolve(QuestionListViewController.self, argument: category)!
        return questionVC
    }
    
    private func answerDetailViewControllerFactory(category: Category, question: Question) -> UIViewController {
        let answerVC = resolve(AnswerDetailViewController.self, arguments: category, question)!
        return answerVC
    }
    
    private func editSheetViewControllerFactory(
        editMode: SheetEditMode,
        categoryId: String,
        question: Question?,
        answerText: String?
    ) -> UIViewController {
        let rootVC = resolve(
            EditSheetViewController.self,
            arguments: editMode, categoryId, question, answerText
        )!
        let editSheetVC = UINavigationController(rootViewController: rootVC)
        editSheetVC.modalPresentationStyle = .fullScreen
        return editSheetVC
    }
}
