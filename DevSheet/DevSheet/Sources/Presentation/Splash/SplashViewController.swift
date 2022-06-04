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

final class SplashViewController: BaseViewController, View {
    
    // MARK: properties
    typealias Reactor = SplashReactor
    private var mainTabFactory: () -> UIViewController

    // MARK: UI
    private let splashImageView: UIImageView = {
       var iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        let randomImgNum = Int.random(in: 1..<4)
        let randomImg = UIImage(named: "splash\(randomImgNum)")
        iv.image = randomImg
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var splashLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: FONT_BM, size: 30)
        lbl.text = "개발족보"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        
    }()
    
    // MARK: initialize
    init(
        reactor: Reactor,
        mainTabFactory: @escaping () -> UIViewController
    ) {
        self.mainTabFactory = mainTabFactory
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
            $0.leading.equalToSuperview().inset(70)
            $0.trailing.equalToSuperview().inset(70)
            $0.height.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        // splashLabel
        self.view.addSubview(splashLabel)
        splashLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(splashImageView.snp.bottom).offset(15)
        }
    }
    
    private func showUpdateAlert() {
        let title = "업데이트"
        let message = "새로운 버전으로 업데이트가 필요합니다."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
          print("debug : update Action ")
        }
        let laterAction = UIAlertAction(title: "나중에", style: .cancel) { [weak self] _ in
            print("debug : later Action ")
            self?.gotoMainTab()
        }
        [laterAction, updateAction].forEach(alert.addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func gotoMainTab() {
        let vc = mainTabFactory()
        present(vc, animated: true, completion: nil)
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
                    let splashDuration: DispatchTimeInterval = .seconds(2)
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + splashDuration
                    ) { [weak self] in
                        self?.gotoMainTab()
                    }
                }
            }).disposed(by: self.disposeBag)
    }
}
