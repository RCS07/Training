//
//  FeedAPIClient.swift
//  FeedsChallenge
//
//  Created by RC on 10/6/21.
//  Copyright © 2021 training. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class FeedAPIClient {
    
    func fetchFeeds(isNext: Bool, completionHandler:@escaping (_ success: Bool,_ data: [FeedModal]) -> Void) {
        var arrFeed: [FeedModal] = [FeedModal]()
        var urlConvertible: Alamofire.URLConvertible?
        if(!isNext) {
            urlConvertible = URL.init(string: "http://www.reddit.com/.json")!
        } else {
            let urlEncoded = " + afterLink".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            let url = "http://www.reddit.com/.json?after=\(urlEncoded!)"

            urlConvertible = URL.init(string: url)!
        }
        Alamofire.request(urlConvertible!, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            if(response.result.isSuccess) {
                let feedsData = JSON(response.result.value as Any)
                if let feeds = feedsData["data"]["children"].array {
                    for feed in feeds {
                        var title = ""
                        var commentCount = 0
                        var score = 0
                        var imageSource = ""
                        var image: UIImage = UIImage()
                        if let eachFeed = feed.dictionary {
                            if let eachFeedData = eachFeed["data"] {
                                title = eachFeedData["title"].string ?? ""
                                commentCount = eachFeedData["num_comments"].intValue
                                score = eachFeedData["score"].intValue
                                imageSource = eachFeedData["thumbnail"].string ?? ""
                            }
                        }
                        let url = URL(string: imageSource)
                        let content = try? Data(contentsOf: url!)
                        image = ((content != nil) ? UIImage(data: content!) : UIImage(named: "thumbnail"))!
                        arrFeed.append(FeedModal(image: image, title: title, comment: String(commentCount), score: String(score)))
                    }
                }
                completionHandler(true, arrFeed)
            } else {
                completionHandler(false, arrFeed)
            }
        }
    }
    
}

