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
    
    func createImageBarButtonItem(
        imageName: String,
        buttonWidth: Int = 30,
        buttonHeight: Int = 30,
        target: Any,
        action: Selector
    ) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: buttonWidth, height: buttonHeight)
        )
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
    
    func createTitleBarButtonItem(
        title: String,
        titleColor: UIColor = .orange,
        titleFont: UIFont = .boldSystemFont(ofSize: 16),
        buttonWidth: Int = 30,
        buttonHeight: Int = 30,
        target: Any,
        action: Selector
    ) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(
            origin: .zero,
            size: .init(width: buttonWidth, height: buttonHeight)
        )
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = titleFont
        btn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
}
