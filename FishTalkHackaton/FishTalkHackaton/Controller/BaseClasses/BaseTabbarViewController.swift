//
//  BaseTabbarViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class BaseTabbarViewController: BaseNavigationViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        for item in (self.tabBarController?.tabBar.items)!{
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
            let unselectedItem = [NSAttributedStringKey.foregroundColor: UIColor.white]
            let selectedItem = [NSAttributedStringKey.foregroundColor: Constants.Colors.CAPTAIN_CHAT_BALOON_COLOR]
            item.setTitleTextAttributes(unselectedItem , for: .normal)
            item.setTitleTextAttributes(selectedItem, for: .selected)
            
        }
        self.tabBarController?.tabBar.barTintColor = Constants.Colors.CAPTAIN_CHAT_BALOON_COLOR
        self.tabBarController?.tabBar.setGradientBackground(colors: [Constants.Colors.MAIN_BLUE_COLOR,Constants.Colors.MAIN_PURPLE_COLOR])
        let sendMessageButton = UIBarButtonItem(image: UIImage(named : "chatBuble")!, style: .plain, target: self, action:  #selector(pushSendMessageController))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(sendMessageButton, animated: true)
        let logoutButton = UIBarButtonItem(image: UIImage(named : "logout")!, style: .plain, target: self, action:  #selector(logoutPressed))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(sendMessageButton, animated: true)
        
        self.navigationController?.navigationBar.topItem?.setLeftBarButton(logoutButton, animated: true)
        
    }
    @objc func pushSendMessageController()  {
        if let sendMessageController = self.storyboard?.instantiateViewController(withIdentifier: "sendMessageController"){
            self.navigationController?.pushViewController(sendMessageController, animated: true)
        }
        
    }
    @objc func logoutPressed()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchRootController()
    }

}
