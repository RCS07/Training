//
//  FeedsViewModal.swift
//  FeedsChallenge
//
//  Created by RC on 10/8/21.
//  Copyright © 2021 training. All rights reserved.
//

import Foundation

protocol FeedsViewModalDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

class FeedsViewModal {
    private weak var delegate: FeedsViewModalDelegate?
    private var isFetchInProgress = false
    private var total = 0
    private var isNextFetch = false
    private var feedsData: [FeedModal] = [FeedModal]()
    
    init(delegate: FeedsViewModalDelegate) {
        self.delegate = delegate
    }
    
    func setIsNextFetch(invoke: Bool) {
        isNextFetch = invoke
    }
    
    func getIsNextFetch() -> Bool {
        return isNextFetch
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return feedsData.count
    }
    
    func feed(at index: Int) -> FeedModal {
        return feedsData[index]
    }
    
    
    func fetchFeeds() {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        
        FeedAPIClient().fetchFeeds(isNext: isNextFetch, completionHandler: { (isSuccess, data) in
                if (isSuccess) {
                    DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.total = data.count
                    for feed in data {
                        self.feedsData.append(feed)
                    }
                    
                    if (self.isNextFetch) {
                        self.setIsNextFetch(invoke: false)
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: data)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        })
    }
    
    private func calculateIndexPathsToReload(from newFeeds: [FeedModal]) -> [IndexPath] {
        let startIndex = feedsData.count - newFeeds.count
        let endIndex = startIndex + newFeeds.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
