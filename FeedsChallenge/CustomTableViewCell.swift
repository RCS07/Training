//
//  CustomTableViewCell.swift
//  FeedsChallenge
//
//  Created by RC on 10/6/21.
//  Copyright © 2021 training. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var imgDisplay: UIImageView!
    @IBOutlet weak var lComment: UILabel!
    @IBOutlet weak var lScore: UILabel!
    
    func configureCell(feed: FeedModal?) {
        lTitle.text = feed?.title
        lComment.text = feed?.comment
        imgDisplay.image = feed?.image
        lScore.text = feed?.score
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
