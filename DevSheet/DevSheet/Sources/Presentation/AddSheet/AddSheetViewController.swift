//
//  AddSheetViewController.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import UIKit
import ReactorKit
import SnapKit

final class AddSheetViewController: BaseViewController, View {
    
    // MARK: properties
    typealias Reactor = AddSheetReactor
    private var category: Category
    
    // MARK: initialize
    init(
        reactor: Reactor,
        category: Category
    ) {
        self.category = category
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
        view.backgroundColor = .blue
        print("debug : AddSheetViewController setupUI category -> \(self.category)")
    }
}

// MARK: Reactor Bind
extension AddSheetViewController {
    func bind(reactor: AddSheetReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AddSheetReactor) {
        
    }
    
    private func bindState(reactor: AddSheetReactor) {
        
    }
}
