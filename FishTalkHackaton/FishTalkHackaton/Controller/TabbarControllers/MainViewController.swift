//
//  MainViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class MainViewController: BaseTabbarViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var Messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    func setDelegates()  {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessages()
        
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
    private func attempReloadTable(){
       
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.HandleReloadDataDelay), userInfo: nil, repeats: false)
    }
    var timer : Timer?
    @objc func HandleReloadDataDelay()  {
        print("TableReloaded")
        self.tableView.reloadData()
    }
    
}
extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Messages.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainChatCell") as! MainChatCell
        cell.message = self.Messages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
   
}
