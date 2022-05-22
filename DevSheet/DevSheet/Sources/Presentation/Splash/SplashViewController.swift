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
    func setupUI() {
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
}

// MARK: Reactor Bind
extension SplashViewController {
    func bind(reactor: SplashReactor) {
        print("Debug  : SplashViewController bind  ")
    }
}
