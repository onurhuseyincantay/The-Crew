//
//  Service.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

let DB_BASE  = Database.database().reference()
let DB_STORAGEBASE = Storage.storage().reference()
class Service {

        static let ds = Service()
    
        private var _REF_USERS = DB_BASE.child("Users")
        private var _FIR_AUTH = Auth.auth()
        private var _REF_MESSAGES = DB_BASE.child("Messages")
        var dataSnapshot = [DataSnapshot].self
        
    
        var REF_MESSAGES: DatabaseReference {
            return _REF_MESSAGES
        }
        
    
        var REF_USERS: DatabaseReference {
            return _REF_USERS
        }
        
        var FIR_AUTH: Auth {
            return _FIR_AUTH
        }
        
    
        func deleteUser(roomId: String){
            _REF_MESSAGES.child(roomId).removeValue()
            
        }
    
    func createFirebaseUser(userData: Dictionary<String,AnyObject>,completion:@escaping (Bool)->()){
            self.createAuthUser(itemData: userData) { (error,user)  in
                if !error{
                    completion(false)
                }else{
                     self._REF_USERS.child(user).updateChildValues(userData)
                     completion(true)
                }
            }
        }
    func getAllUsers(completion : @escaping (Bool,[User]) -> ()) {
        var users = [User]()
        Service.ds.REF_USERS.observe(.value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                                for snap in snapshot{
                                    if let dict = snap.value as? Dictionary<String,AnyObject>{
                                        let id = snap.key
                                        let email = dict["Email"] as! String
                                        let fullname = dict["FullName"] as! String
                                        let password = dict["Password"] as! String
                                        let iscaptain = dict["IsCaptain"] as! Bool
                                        let imageurl = dict["ImageUrl"] as! String
                                        let jobtitle = dict["JobTitle"] as! String
                                        let workstartdate = dict["WorkStartDate"] as! String
                                        let user = User(id: id, email: email, fullname: fullname, workstartDate:workstartdate, isCaptain: iscaptain, password: password,imageurl : imageurl)
                                        users.append(user)
                
                                    }
                                    completion(false, users)
                                }
        }
        }) { (error) in
            print(error.localizedDescription)
            completion(true, [User]())
        }
//        Service.ds.REF_USERS.observe(.value, with: { (snapshots) in
//            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
//                for snap in snapshot{
//                    if let dict = snap.value as? Dictionary<String,AnyObject>{
//                        let id = snap.key
//                        let email = dict["Email"] as! String
//                        let fullname = dict["FullName"] as! String
//                        let password = dict["Password"] as! String
//                        let iscaptain = dict["IsCaptain"] as! Bool
//                        let imageurl = dict["ImageUrl"] as! String
//                        let jobtitle = dict["JobTitle"] as! String
//                        let workstartdate = dict["WorkStartDate"] as! String
//                        let user = User(id: id, email: email, fullname: fullname, workstartDate:workstartdate, isCaptain: iscaptain, password: password,imageurl : imageurl)
//                        users.append(user)
//
//                    }
//                    completion(false, users)
//                }
//            }
//        }) { (error) in
//
//            print(error.localizedDescription)
//            completion(true, [User]())
//        }
    }
    func getMessages(completion : @escaping (Bool,[Message]) -> ()) {
        REF_MESSAGES.observe(.value, with: { (snapshots) in
            var Messages = [Message]()
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let dict = snap.value as? Dictionary<String,AnyObject>{
                        let id = snap.key
                        let messagedesc = dict["Message"] as! String
                        let imageurl = dict["ImageUrl"] as! String
                        let messagesenddatenumber = dict["MessageSendDate"] as! NSNumber
                        let messagesenddate = Date(timeIntervalSince1970: TimeInterval(messagesenddatenumber)).toString()
                        let message = Message(messagedesc: messagedesc, imageUrl: imageurl, messagesenddate: messagesenddatenumber, id: id)
                        Messages.append(message)
                    }
                }
                completion(false,Messages)
            }
        }) { (error) in
            print(error.localizedDescription)
            completion(true,[Message]())
        }
    }
    
        func addMessage(itemData : Dictionary<String,AnyObject>){
            REF_MESSAGES.childByAutoId().updateChildValues(itemData)
        }
    func createAuthUser(itemData : Dictionary<String,AnyObject>, completion : @escaping (_ result : Bool,_ id:String) -> ())  {
        _FIR_AUTH.createUser(withEmail: itemData["Email"] as! String , password: itemData["Password"] as! String) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                completion(false,"")
            }else{
                completion(true,(user?.uid)!)
            }
        }
    }
    
    
        func getUser(id: String, completion: @escaping (_ result: Bool, _ user: User) -> ()){
            var user: User!
            print(id)
            _REF_USERS.child(id).observe(.value){ (snapshots) in
                
                if let dict = snapshots.value as? Dictionary<String,AnyObject> {
                    let id = snapshots.key
                    let email = dict["Email"] as! String
                    let fullname = dict["FullName"] as! String
                    let password = dict["Password"] as! String
                    let iscaptain = dict["IsCaptain"] as! Bool
                    let imageurl = dict["ImageUrl"] as! String
                    let jobtitle = dict["JobTitle"] as! String
                    let workstartdate = dict["WorkStartDate"] as! String
                    
                    user = User(id: id, email: email, fullname: fullname, workstartDate: workstartdate, isCaptain: iscaptain ,password : password, imageurl: imageurl )
                    completion(true,user)
                }
            }
        }
}

