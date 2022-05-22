//
//  SplashViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/16/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxViewController
import RxOptional

class SplashViewController: UIViewController, View {
    
    // MARK: properties
    typealias Reactor = SplashReactor
    var disposeBag: DisposeBag = .init()
    let FONT_BM = "BMHANNA11yrsold"

    // MARK: UI
    let splashImageView: UIImageView = {
       var iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        let randomImgNum = Int.random(in: 1..<4)
        if let randomImg = UIImage(named: "splash\(randomImgNum)") {
            iv.image = randomImg
        }
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var splashLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: FONT_BM, size: 40)
        lbl.text = "개발족보"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        
    }()
    
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
        setupUI()
    }

    // MARK: methods
    private func setupUI() {
        // view
        self.view.backgroundColor = .white
        
        // imageView
        self.view.addSubview(splashImageView)
        splashImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(270)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        // splashLabel
        self.view.addSubview(splashLabel)
        splashLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(splashImageView.snp.bottom).offset(10)
        }
    }
    
    private func showUpdateAlert() {
        let title = "업데이트"
        let message = "새로운 업데이트"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "update", style: .default) { _ in
          print("debug : update Action ")
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
            print("debug : cancel Action ")
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        [cancelAction, updateAction].forEach(alert.addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func gotoHomeTab() {
        let vc = TestViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: Reactor Bind
extension SplashViewController {
    func bind(reactor: SplashReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SplashReactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindState(reactor: SplashReactor) {
        reactor.state
            .map { $0.shouldUpdate }
            .filterNil()
            .subscribe(onNext: { [weak self] result in
                if result == true {
                    self?.showUpdateAlert()
                } else {
                    self?.gotoHomeTab()
                }
            }).disposed(by: self.disposeBag)
    }
}
