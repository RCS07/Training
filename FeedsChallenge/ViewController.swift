//
//  ViewController.swift
//  FeedsChallenge
//
//  Created by RC on 10/6/21.
//  Copyright © 2021 training. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching, FeedsViewModalDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    var viewModal: FeedsViewModal!
    let resuableIdentifier = "feedsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            myTableView.prefetchDataSource = self
        } else {
            // Fallback on earlier versions
        }
        viewModal = FeedsViewModal(delegate: self)
        
        viewModal.fetchFeeds()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuableIdentifier) as! CustomTableViewCell
        if isLoadingCell(for: indexPath) {
            cell.configureCell(feed: .none)
        } else {
            cell.configureCell(feed: viewModal.feed(at: indexPath.row))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModal.setIsNextFetch(invoke: true)
            viewModal.fetchFeeds()
        }
    }
    
    func onFetchCompleted(with rowsToReload: [IndexPath]?) {
        guard let rowsToReload = rowsToReload else {
            myTableView.reloadData()
            return
        }
        let indexPathsToReload = visibleRowsToReload(with: rowsToReload)
        myTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == viewModal.currentCount-1
    }
    
    func visibleRowsToReload(with indexPaths: [IndexPath]) -> [IndexPath] {
        let visibleRows = myTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(visibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

