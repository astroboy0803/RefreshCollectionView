//
//  SuggestionViewController.swift
//  RefreshCollectionView
//
//  Created by i9400506 on 2020/6/15.
//  Copyright © 2020 i9400506. All rights reserved.
//

import UIKit

protocol SuggestionViewDelegate: class {
  func didSelect(text: String)
}

struct SuggestionCellData: SuggestionCellable {
    var cellID: String = UUID().uuidString
    var title: String
    var count: Int
}

class SuggestionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _suggestions: [SuggestionCellData] = []
    
    weak var delegate: SuggestionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SuggestionCell", bundle: nil), forCellReuseIdentifier: "SuggestionCell")
    }
    
    final func showSuggestions(datas: [SuggestionCellData]) {
        self._suggestions = datas.sorted {
            return $0.count > $1.count
        }
        self.tableView.reloadData()
    }
}

extension SuggestionViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
        // 1 讓searchbar的text = 選擇的內容
        // 2 關閉suggestion畫面
        // 3 顯示主頁
        self.delegate?.didSelect(text: self._suggestions[indexPath.row].title)
    }
}

extension SuggestionViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        if let sCell = cell as? SuggestionCell {
            sCell.setupCell(data: self._suggestions[indexPath.row])
        }
        return cell
    }
}
