//
//  BaseViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/23/22.
//

import UIKit
import Swinject
import RxSwift

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
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
