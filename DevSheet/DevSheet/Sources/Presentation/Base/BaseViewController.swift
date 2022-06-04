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
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: methods
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
