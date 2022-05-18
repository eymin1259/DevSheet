//
//  SplashViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/16/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa

class SplashViewController: UIViewController, View {
    
    // MARK: properties
    typealias Reactor = SplashReactor
    var disposeBag: DisposeBag = .init()

    // MARK: UI
    
    // MARK: initialize
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

    // MARK: methods
}


// MARK: Reactor Bind
extension SplashViewController {
    func bind(reactor: SplashReactor) {
        print("Debug  : SplashViewController bind  ")
    }
}
