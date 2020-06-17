//
//  SuggestionCell.swift
//  RefreshCollectionView
//
//  Created by i9400506 on 2020/6/15.
//  Copyright © 2020 i9400506. All rights reserved.
//

import UIKit

protocol SuggestionCellable {
    var cellID: String { get set }
    var title: String { get set }
    var count: Int { get set }
}

class SuggestionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    final func setupCell(data: SuggestionCellable) {
        self.titleLabel.text = data.title
        self.countLabel.text = "共\(data.count)筆"
    }
}
