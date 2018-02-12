//
//  ChatViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class CoWorkerViewController: BaseTabbarViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var activityController: UIActivityViewController!
    
    var Users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let printButton = UIBarButtonItem(image: UIImage(named:"print-icon")!, style: .plain, target: self, action: #selector(printCoWorkers))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(printButton, animated: true)
        self.getUsers {
            self.attempReloadTable()
            
        }
    }
    
    func getUsers(completion : @escaping () -> ())  {
        Service.ds.getAllUsers { (error, Users) in
            if !error{
                self.Users = Users
                print("Oki Doki")
                completion()
            }else{
                print("GG")
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
    
  @objc func printCoWorkers()  {
        if self.Users.count != 0{
            let pdfUrl = Helper.createPdfFromTableView(self.tableView)
            
            self.activityController = UIActivityViewController(activityItems: [pdfUrl], applicationActivities: nil)
            self.activityController.popoverPresentationController?.sourceView = self.view
            self.activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            self.present(self.activityController, animated: true, completion: nil)
        }else {
            self.present(Helper.showAlertView(title: "", message: "No CoWorking "), animated: true, completion: nil)
        }
    }

}

extension CoWorkerViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coWorkerCell") as! CoWorkerCell
        cell.user = self.Users[indexPath.row]
        return cell
    }

}
