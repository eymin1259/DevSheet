//
//  BaseViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import UIKit
import Swinject
import RxSwift
import SnapKit
import Loaf
import ProgressHUD

class BaseViewController: UIViewController {
 
    // MARK: properties
    let FONT_BM = "BMHANNA11yrsold"
    var disposeBag: DisposeBag = .init()
    var DIContainer: Container? {
        if let uiSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate,
           let sceneDelegate = uiSceneDelegate as? SceneDelegate {
            return sceneDelegate.container
        }
        return nil
    }
    
    // MARK: UI
    let navigationLineView: UIView = {
        var line = UIView()
        line.backgroundColor = .systemGray4
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    lazy var backBarBtn: UIBarButtonItem = {
        let title = "뒤로"
        var barBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        return barBtn
    }()
    
    lazy var questionTitleTextView: UITextView = {
        var textView = UITextView()
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.font = .boldSystemFont(ofSize: 20)
        textView.textColor = .label
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let titleContentdividerView: UIView = {
        var divider = UIView()
        divider.backgroundColor = .systemGray5
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    let answerContentTextView: UITextView = {
        var textView = UITextView()
        textView.autocorrectionType = .no
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .darkGray
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.text = ""
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: methods
    func addQuestionTitleTextView() {
        self.view.addSubview(questionTitleTextView)
        questionTitleTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(10)
        }
    }
    
    func addTitleContentdividerView() {
        self.view.addSubview(titleContentdividerView)
        titleContentdividerView.snp.makeConstraints {
            $0.top.equalTo(questionTitleTextView.snp.bottom)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    
    func addAnswerContentTextView() {
        self.view.addSubview(answerContentTextView)
        answerContentTextView.snp.makeConstraints {
            $0.top.equalTo(titleContentdividerView.snp.bottom).offset(3)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
        }
    }
    
    func addNavigationLineView() {
        self.view.addSubview(navigationLineView)
        navigationLineView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func showErrorToast(message: String?) {
        let errMsg = message ?? "에러 발생"
        Loaf(errMsg, state: .error, location: .bottom, sender: self).show()
    }
    
    func showshowSucceedHud(message: String?, completion: (() -> Void)?) {
        let msg = message
        let delay: DispatchTimeInterval = .milliseconds(1600)
        ProgressHUD.showSucceed(msg, interaction: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion?()
        }
    }
    
    func showLoadingHud() {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.show(nil, interaction: false)
    }
    
    func hideLoadingHud() {
        let delay: DispatchTimeInterval = .milliseconds(300)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ProgressHUD.dismiss()
        }
    }
    
    func showActionSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        let actionSheet =  UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { action in
            actionSheet.addAction(action)
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { action in
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
