//
//  CoWorkerCell.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class CoWorkerCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var startDate : UILabel!
    @IBOutlet weak var workerID : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var user : User!{
        didSet{
            self.fullNameLabel.text = user.fullname
            self.workerID.text  = user.id
            self.startDate.text = user.workstartDate
            if user.isCaptain{
                self.profileImage.loadImagesWithCache(urlString:user.imageUrl!)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
