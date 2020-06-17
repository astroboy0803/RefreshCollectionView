//
//  ViewController.swift
//  RefreshCollectionView
//
//  Created by i9400506 on 2020/5/13.
//  Copyright © 2020 i9400506. All rights reserved.
//

import UIKit

enum Selection: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    
    func getTitle() -> String {
        switch self {
        case .one:
            return "Page 1"
        case .two:
            return "Page 2"
        case .three:
            return "Page 3"
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var verLabel: UILabel!
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func manualRefresh(_ sender: Any) {
        guard let button = sender as? UIButton, let selected = Selection(rawValue: button.tag), let navVC = self.children.first as? UINavigationController, let collectionVC = navVC.viewControllers.first as? MyCollectionViewController else {
            return
        }
        collectionVC.changeTab(selected: selected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.verLabel.text = "iOS \(UIDevice.current.systemVersion)"
        
        self.setupContentView()
    }
    
    final private func setupContentView() {
        let sboard = UIStoryboard(name: "Main", bundle: nil)
        let collectionVC = sboard.instantiateViewController(withIdentifier: "\(MyCollectionViewController.self)")
        let navVC = UINavigationController(rootViewController: collectionVC)
        //navVC.setNavigationBarHidden(true, animated: false)
        navVC.view.translatesAutoresizingMaskIntoConstraints = false
        //navVC.hidesBarsOnSwipe = true
        //navVC.hidesBarsOnTap = true
        //navVC.hidesBarsWhenKeyboardAppears = true
        //navVC.hidesBarsWhenVerticallyCompact = true
        //navVC.hidesBottomBarWhenPushed = true

        let navView: UIView = navVC.view
                
        // 處理事件
        self.addChild(navVC)
        
        // 畫面顯示
        self.contentView.addSubview(navView)
        
        // 設定constraint
        NSLayoutConstraint.activate([
            navVC.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            navVC.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            navVC.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            navVC.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
