//
//  NewViewController.swift
//  RefreshCollectionView
//
//  Created by 黃宇新 on 2020/7/4.
//  Copyright © 2020 i9400506. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
    
    @IBOutlet weak var verLabel: UILabel!
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    
    @IBAction func manualRefresh(_ sender: Any) {
        guard let button = sender as? UIButton, let selected = Selection(rawValue: button.tag), let navVC = self.children.first as? UINavigationController, let collectionVC = navVC.viewControllers.first as? NewMyCollectionViewController else {
            return
        }
        collectionVC.changeTab(selected: selected)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.verLabel.text = "iOS \(UIDevice.current.systemVersion)"
    }
}
