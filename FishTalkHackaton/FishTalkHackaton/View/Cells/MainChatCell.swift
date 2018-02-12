//
//  MainChatCell.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class MainChatCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var dateLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var message : Message?{
        didSet{
            descLabel.text = (message?.messageDesc)
            let url = "https://disneyaile.disneyturkiye.com.tr/wp-content/uploads/2017/04/disneyinspired-potc-quiz-v02-660x660-1.jpg"
            profileImage.loadImagesWithCache(urlString: url)
            dateLabel.text = Date(timeIntervalSince1970: TimeInterval((message?.messageSendDate)!)).toString()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
