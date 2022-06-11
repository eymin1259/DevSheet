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
        
        register(SQLiteService.self) { _ in
            return SQLiteServiceImpl()
        }.inObjectScope(.container)
    }
    
    private func registerRepository() {
        register(VersionRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let sqlite = r.resolve(SQLiteService.self)!
            let repo = VersionRepositoryImpl(
                firebaseService: firebase,
                sqliteService: sqlite
            )
            return repo
        }
        
        register(CategoryRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let sqlite = r.resolve(SQLiteService.self)!
            let repo = CategoryRepositoryImpl(
                firebaseService: firebase,
                sqliteService: sqlite
            )
            return repo
        }.inObjectScope(.transient)
        
        register(QuestionRepository.self) { r in
            let firebase = r.resolve(FirebaseService.self)!
            let sqlite = r.resolve(SQLiteService.self)!
            let repo = QuestionRepositoryImpl(
                firebaseService: firebase,
                sqliteService: sqlite
            )
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
            let question = r.resolve(QuestionUseCase.self)!
            let answer = r.resolve(AnswerUseCase.self)!
            let useCase = SheetUseCaseImpl(
                questionUseCase: question,
                answerUseCase: answer
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
        
        register(CategoryListReactor.self) { (r: Resolver,
                                              categoryGroup: MainTab) in
            let useCase = r.resolve(CategoryUseCase.self)!
            let reactor = CategoryListReactor(
                categoryGroup: categoryGroup,
                categoryUseCase: useCase
            )
            return reactor
        }.inObjectScope(.transient)
        
        register(QuestionListReactor.self) { (r: Resolver,
                                              categoryGroup: MainTab,
                                              category: Category) in
            let useCase = r.resolve(QuestionUseCase.self)!
            let reactor = QuestionListReactor(
                categoryGroup: categoryGroup,
                category: category,
                questionUseCase: useCase
            )
            return reactor
        }.inObjectScope(.transient)
        
        register(AnswerDetailReactor.self) { (r: Resolver,
                                              category: Category,
                                              question: Question) in
            let categoryUseCase = r.resolve(CategoryUseCase.self)!
            let questionUseCase = r.resolve(QuestionUseCase.self)!
            let answerUseCase = r.resolve(AnswerUseCase.self)!
            let reactor = AnswerDetailReactor(
                category: category,
                question: question,
                categoryUseCase: categoryUseCase,
                questionUseCase: questionUseCase,
                answerUseCase: answerUseCase
            )
            return reactor
        }.inObjectScope(.transient)
        
        register(EditSheetReactor.self) { (r: Resolver,
                                           editMode: SheetEditMode,
                                           categoryId: String,
                                           question: Question?,
                                           answerText: String) in
            let usecase = r.resolve(SheetUseCase.self)!
            let reactor = EditSheetReactor(
                editMode: editMode,
                categoryId: categoryId,
                question: question,
                answerText: answerText,
                sheetUseCase: usecase
            )
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
            let reactor = r.resolve(
                CategoryListReactor.self,
                argument: mainTab
            )!
            let vc = CategoryListViewController(
                reactor: reactor,
                questionListVCFactory: self.questionListViewControllerFactory(
                    categoryGroup:category:
                )
            )
            return vc
        }.inObjectScope(.transient)
        
        register(
            QuestionListViewController.self
        ) { [unowned self] (r: Resolver, categoryGroup: MainTab, category: Category) in
            let reactor = r.resolve(
                QuestionListReactor.self,
                arguments: categoryGroup, category
            )!
            let vc = QuestionListViewController(
                reactor: reactor,
                answerDetailFactory: self.answerDetailViewControllerFactory(category:question:),
                editSheetFactory: self.editSheetViewControllerFactory(
                    editMode:categoryId:question:answerText:
                )
            )
            return vc
        }.inObjectScope(.transient)
        
        register(AnswerDetailViewController.self) { [unowned self] (r: Resolver,
                                                                    category: Category,
                                                                    question: Question) in
            let reactor = r.resolve(
                AnswerDetailReactor.self,
                arguments: category, question
            )!
            let vc = AnswerDetailViewController(
                reactor: reactor,
                editSheetFactory: self.editSheetViewControllerFactory(
                    editMode:categoryId:question:answerText:
                )
            )
            return vc
        }.inObjectScope(.transient)
        
        register(EditSheetViewController.self) { (r: Resolver,
                                                  editMode: SheetEditMode,
                                                  categoryId: String,
                                                  question: Question?,
                                                  answerText: String) in
            let reactor = r.resolve(
                EditSheetReactor.self,
                arguments: editMode, categoryId, question, answerText
            )!
            let vc = EditSheetViewController(reactor: reactor)
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
    
    private func questionListViewControllerFactory(
        categoryGroup: MainTab,
        category: Category
    ) -> UIViewController {
            let questionVC = resolve(
                QuestionListViewController.self,
                arguments: categoryGroup, category
            )!
            return questionVC
        }
    
    private func answerDetailViewControllerFactory(
        category: Category,
        question: Question
    ) -> UIViewController {
        let answerVC = resolve(AnswerDetailViewController.self, arguments: category, question)!
        return answerVC
    }
    
    private func editSheetViewControllerFactory(
        editMode: SheetEditMode,
        categoryId: String,
        question: Question?,
        answerText: String
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
