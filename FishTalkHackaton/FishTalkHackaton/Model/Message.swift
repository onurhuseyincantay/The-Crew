//
//  File.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 11.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
class Message {
    let id : String
    let messageDesc : String
    let imageUrl : String
    let messageSendDate : NSNumber
    init(messagedesc : String , imageUrl : String,messagesenddate : NSNumber,id : String) {
        self.messageDesc = messagedesc
        self.imageUrl = imageUrl
        self.messageSendDate = messagesenddate
        self.id = id
    }
}
