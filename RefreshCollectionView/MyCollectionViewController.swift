//
//  MyCollectionViewController.swift
//  RefreshCollectionView
//
//  Created by i9400506 on 2020/5/22.
//  Copyright © 2020 i9400506. All rights reserved.
//

import UIKit

class MyCollectionViewController: UIViewController {
    
    private let _cellWidth: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    private let _cellHeight: CGFloat = {
        return UIScreen.main.bounds.height / 6
    }()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var _oneLoading: Bool = false
    private var _twoLoading: Bool = false
    private var _threeLoading: Bool = false
    
    lazy private var _oneData: [String] = {
        var result = [String]()
        for _ in 0..<100 {
            result.append(self.getElement())
        }
        return result
    }()
    lazy private var _twoData: [String] = {
        var result = [String]()
        for _ in 0..<4 {
            result.append(self.getElement())
        }
        return result
    }()
    lazy private var _threeData: [String] = {
        var result = [String]()
        for _ in 0..<2 {
            result.append(self.getElement())
        }
        return result
    }()
    
    private var _showData = [String]()
    
    // 若要實作suggestion功能, 請自行實作controller並指定searchResultsController
    // ex: searchController = UISearchController(searchResultsController: somecontroller)
    // 若給nil, 則為預設格式
    private var searchController: UISearchController!
    
    private var _selected: Selection = .one
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if #available(iOS 10.0, *) {            
            collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            // Fallback on earlier versions
        }
        collectionViewLayout.estimatedItemSize = CGSize(width: self._cellWidth, height: self._cellHeight)
        
        self.updateTitle()
        
        self.setupNavBar()
        
        self.setupSearch()
        
        self.setupRefresh()
        
        self.setupShowData(selected: self._selected)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    final func changeTab(selected: Selection) {
        self.choiceTab(selected: selected)
        self.updateTitle()
        self.setupSearchBarStatus()
    }
    
    final private func setupNavBar() {
        // 文字自動大小
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        if #available(iOS 13.0, *) {
//            let barAppearance =  UINavigationBarAppearance()
//            barAppearance.configureWithTransparentBackground()
//            //barAppearance.configureWithDefaultBackground()
//            //barAppearance.configureWithOpaqueBackground()
//            self.navigationItem.standardAppearance = barAppearance
//        }
    }
    
    final private func getElement() -> String {
        return "\(Int.random(in: 1...20))"
    }
    
    final private func setupSearchBarStatus() {
        let canSearch: Bool
        switch self._selected {
        case .one:
            canSearch = self._oneData.count > 0
        case .two:
            canSearch = self._twoData.count > 0
        case .three:
            canSearch = self._threeData.count > 0
        }
        // 讓search bar無法運作
        // 1 searchController不見
        if canSearch {
            self.navigationItem.searchController = self.searchController
        } else {
            self.navigationItem.searchController = nil
        }
        // 2 searchBar的isUserInteractionEnabled為false(無法點選)
        // hidden效果不好, 會留一個空白空間
        //self.searchController.searchBar.isUserInteractionEnabled = canSearch
        //self.searchController.searchBar.isHidden = !canSearch
    }
}

// MARK: - SearchController
extension MyCollectionViewController {
    final private func setupSearch() {
        let suggestionVC = SuggestionViewController(nibName: "SuggestionViewController", bundle: nil)
        suggestionVC.delegate = self
        self.searchController = UISearchController(searchResultsController: suggestionVC)
//        if #available(iOS 13.0, *) {
//            self.searchController.searchBar.searchTextField.backgroundColor = .green
//            self.searchController.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//            self.searchController.searchBar.searchTextField.placeholder = "keyword"
//        } else {
//            // Fallback on earlier versions
//        }
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.autocorrectionType = .no
        self.searchController.searchBar.placeholder = "請輸入搜尋內容"
        // 避免插入貼上前後出現空白
        self.searchController.searchBar.smartInsertDeleteType = .no
        
        // 設定當searchbar為firstresponse時是否灰背景, 一般會設true(開啟)
        // 如果有設定segmented, 要改為false, 否則點選選單就會跳掉
        self.searchController.dimsBackgroundDuringPresentation = false

        // 設定segmented title
        self.searchController.searchBar.scopeButtonTitles = Selection.allCases.map { (type) -> String in
            return type.getTitle()
        }
        
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
        
        self.setupSearchBarStatus()
    }
}

extension MyCollectionViewController: SuggestionViewDelegate {
    func didSelect(text: String) {
        // 離開seachbar
        self.searchController.isActive = false
        // 塞入searchbar內容
        self.searchController.searchBar.text = text
    }
}

extension MyCollectionViewController: UISearchControllerDelegate {
    // MARK: search被叫起來時，讓result畫面顯示(跳出suggestion)
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}

extension MyCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // searchBar按下取消鈕
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // searchBar按下enter觸發
        self.didSelect(text: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // 點選segment會觸發
    }
}

extension MyCollectionViewController: UISearchResultsUpdating {
    // MARK: filter method
    func updateSearchResults(for searchController: UISearchController) {
        
        // TODO:
        if #available(iOS 13.0, *) {
            if searchController.searchBar.searchTextField.isFirstResponder {
                searchController.showsSearchResultsController = true
            }
        }
        
        // self.searchController.isActive
        // 1 false -> tap suggestion cell or tap done
        // 2 true -> key in filter condition
        
        var sources = self.getSourceData(selected: self._selected)
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            sources = sources.filter { (str) -> Bool in
                str.contains(searchText)
            }
        }
        if self.searchController.isActive {
            // SearchController已開啟狀態 - suggestion
            if let suggestionsVC = searchController.searchResultsController as? SuggestionViewController {
                suggestionsVC.showSuggestions(datas: self.getSuggestDatas(sources: sources))
            }
            return
        }
        // SearchController已關閉狀態 - 顯示符合條件資料
        self._showData = sources
        self.collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    private func getSuggestDatas(sources: [String]) -> [SuggestionCellData] {
        var countMap = [String: Int]()
        sources.forEach {
            countMap[$0, default: 0] += 1
        }
        var results = [SuggestionCellData]()
        for (title, count) in countMap {
            results.append(SuggestionCellData(title: title, count: count))
        }
        return results
    }
}

// MARK: - UIRefresh
extension MyCollectionViewController {
    // MARK: 設定refreshControl
    final private func setupRefresh() {
        guard self.collectionView.refreshControl == nil else {
            return
        }
        
        let refreshControl = UIRefreshControl()
        // 設定狀態
        refreshControl.attributedTitle = NSAttributedString(string: "資料更新中")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    // MARK: 更新navigator title
    final private func updateTitle() {
        self.navigationItem.title = self._selected.getTitle()
    }
    
    // MARK: 切換分頁
    final private func choiceTab(selected: Selection) {
        self._selected = selected
        self.setupShowData(selected: selected)
        if selected == .one {
            self.loadDatas()
            return
        }

        // 載入資料(舊)
        self.loadDatas { (_) in
            self.collectionView.refreshControl?.beginRefreshing()
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                // 開啟 refresh control
                let height: CGFloat = self.collectionView.refreshControl?.bounds.height ?? 0
                if let barFrame = self.navigationController?.navigationBar.frame {
                    self.navigationController?.navigationBar.frame = CGRect(origin: barFrame.origin, size: CGSize(width: barFrame.width, height: barFrame.height + height))
                } else {
                    self.collectionView.contentOffset = CGPoint(x: 0, y: 0 - height)
                }
                
            }) { (_) in
                guard !self.getLoading(selected: selected) else {
                    // TODO: test
                    print("\(selected) is loading")
                    return
                }
                self.setupLoading(selected: selected, isLoading: true)
                self.downloadDatas {
                    self.setupLoading(selected: selected, isLoading: false)
                    print("\(selected) is done")
                    if selected == self._selected {
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                            self.collectionView.refreshControl?.endRefreshing()
                        }) { (_) in
                            self.loadDatas()
                        }
                    }
                }
            }
        }
    }
    
    final private func getSourceData(selected: Selection) -> [String] {
        switch selected {
        case .one:
            return self._oneData
        case .two:
            return self._twoData
        case .three:
            return self._threeData
        }
    }
    
    final private func setupShowData(selected: Selection) {
        switch selected {
        case .one:
            self._showData = self._oneData
        case .two:
            self._showData = self._twoData
        case .three:
            self._showData = self._threeData
        }
    }

    // MARK: refresh control
    @objc final private func refresh() {
        let selected = self._selected
        self.downloadDatas { [weak self] in
            guard let self = self else {
                return
            }
            if selected == self._selected {
                self.loadDatas(completion: nil)
            }
        }
    }

    // MARK: 載入資料
    final private func loadDatas(completion: ((Bool) -> Void)? = nil) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if self.collectionView.refreshControl?.isRefreshing ?? false {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }) { (_) in
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: completion)
        }
    }

    // MARK: 下載資料
    final private func downloadDatas(callback: @escaping () -> Void) {
        let selected = self._selected
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            var newContents = [String]()
            for _ in 0..<2 {
                newContents.append(self.getElement())
            }
            switch selected {
            case .one:
                self._oneData.append(contentsOf: newContents)
            case .two:
                self._twoData.append(contentsOf: newContents)
            case .three:
                self._threeData.append(contentsOf: newContents)
            }
            self.setupShowData(selected: selected)
            DispatchQueue.main.async {
                callback()
            }
        }
    }

    // MARK: 設定loading flag
    final private func setupLoading(selected: Selection, isLoading: Bool) {
        switch selected {
        case .one:
            self._oneLoading = isLoading
        case .two:
            self._twoLoading = isLoading
        case .three:
            self._threeLoading = isLoading
        }
    }

    final private func getLoading(selected: Selection) -> Bool {
        switch selected {
        case .one:
            return self._oneLoading
        case .two:
            return self._twoLoading
        case .three:
            return self._threeLoading
        }
    }
}

// MARK: -  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MyCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._showData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefreshCell", for: indexPath)
        if let refreshCell = cell as? RefreshCell {
            let value = self._showData[indexPath.row]
            refreshCell.msgLabel.text = "data: [\(value)]"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(collectionView.contentOffset)
    }
    
    // MARK: 設定牌卡layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self._cellWidth, height: self._cellHeight)
    }
}

// MARK - UIScrollViewDelegate
extension MyCollectionViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    // MARK: scroll時會觸發
    // 用來控制navigationBar是否顯示
    // 一般是hidding效能比較好, 但由於會有動畫(activitiy)在執行, 故改alpha
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let nowY = scrollView.contentOffset.y
        var alpha: CGFloat = (0 - nowY) / barHeight
        if alpha > 1 {
            alpha = 1
        }
        self.navigationController?.navigationBar.alpha = alpha
    }
}
