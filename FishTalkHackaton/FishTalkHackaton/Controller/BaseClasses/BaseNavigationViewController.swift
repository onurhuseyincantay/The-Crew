//
//  BaseNavigationViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UIViewController {
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.navigationBar.setGradientBackground(colors: [Constants.Colors.MAIN_BLUE_COLOR,Constants.Colors.MAIN_PURPLE_COLOR])
        self.navigationController?.navigationBar.tintColor = UIColor.white
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.topItem?.title = self.title
        self.navigationController?.navigationBar.shadowImage = nil
        self.getUser {
            if !self.currentUser.isCaptain && self.tabBarController?.selectedIndex != 0{
                self.showDefaultAlert(title: "Permission Denied", message: "You are not permissioned to be here", button: "Okey", action: { (action) in
                    
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func getUser(completion : @escaping () -> ())  {
        Service.ds.getUser(id: UserDefaults.standard.value(forKey: "userId") as! String) { (error, user) in
            if !error{
                print("Hocam GG")
            }else{
                self.currentUser = user
                completion()
            }
        }
    }
    

}
