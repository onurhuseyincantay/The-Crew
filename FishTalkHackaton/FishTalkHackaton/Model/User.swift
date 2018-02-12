//
//  User.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation

class User {

    let id : String
    let email : String
    let fullname : String
    let workstartDate : String?
    let password : String
    let isCaptain : Bool
    let imageUrl : String?
    init(id : String,email:String,fullname : String,workstartDate : String,isCaptain : Bool,password : String,imageurl : String?) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.workstartDate = workstartDate
        self.isCaptain = isCaptain
        self.password = password
        self.imageUrl = imageurl
    }
    func exportDictionary() -> Dictionary<String,AnyObject>{
        
        let dummyDictionary: Dictionary<String,AnyObject> = [
            "FullName" : fullname as AnyObject,
            "IsCaptain": isCaptain as AnyObject,
            "Password" : password as AnyObject,
            "Email" : email as AnyObject,
            "WorkStartDate" : (Date().toString()) as AnyObject,
            "ImageUrl" : imageUrl as AnyObject
        ]
        return dummyDictionary
    }
}
