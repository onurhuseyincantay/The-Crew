//
//  sendMessageViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class sendMessageViewController: BaseNavigationViewController,UITextFieldDelegate {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var messageTextField : UITextField!
    
    var Messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.messageTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessages()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendPressed()
        return true
    }
    func sendPressed()  {
        guard let message = messageTextField.text , !message.isEmpty else {
            self.showDefaultAlert(title: "Warning !", message: "Don't Try To send Empty Messages !", button: "Okey")
            return
        }
        let dict = ["Message":message,"ImageUrl":"https://disneyaile.disneyturkiye.com.tr/wp-content/uploads/2017/04/disneyinspired-potc-quiz-v02-660x660-1.jpg","MessageSendDate":Date().timeIntervalSince1970 ] as [String : Any]
        Service.ds.addMessage(itemData: dict as Dictionary<String, AnyObject>)
        self.messageTextField.text = nil
    }
    
    func getMessages()  {
        Service.ds.getMessages { (error, messages) in
            if  error{
                print("GG")
            }else{
                self.Messages = messages
                self.Messages.sort(by: { (message1, message2) -> Bool in
                    return message1.messageSendDate.intValue < message2.messageSendDate.intValue
                })
                self.tableView.reloadData()
                print("Mesaj Vaaaaar")
            }
        }
    }
    func deleteMessage(index : IndexPath) {
            //delete rows in tableView
            Service.ds.REF_MESSAGES.child(self.Messages[index.row].id).removeValue()
            self.Messages.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .automatic)
            self.tableView.reloadData()
        
    }
    
}
extension sendMessageViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainChatCell") as! MainChatCell
        cell.message = self.Messages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .default, title: "Delete Message") { (action, indexPath) in
            if self.currentUser.isCaptain{
                self.deleteMessage(index: indexPath)
            }else {
                self.present(Helper.showAlertView(title: "To Delete a Message You Should be a Captain.", message: ""), animated: true, completion: nil)
            }
        }
        return [Delete]
    }
 
    
}
