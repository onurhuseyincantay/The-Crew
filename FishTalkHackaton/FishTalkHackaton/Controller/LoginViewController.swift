//
//  ViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var userInfo: User!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showPassPressed (_ sender : UIButton){
        self.passwordTextField.isSecureTextEntry = !(self.passwordTextField.isSecureTextEntry)
    }
    
    @IBAction func loginPressed(_ sender : UIButton){
        guard let email = self.emailTextField.text , !email.isEmpty else {
            self.showDefaultAlert(title: "Warning !", message: "Please Fill your ", button: "Tamam")
            return
        }
        guard let password  = self.passwordTextField.text , !password.isEmpty else {
            self.showDefaultAlert(title: "Hata Mesajı", message: "Lütfen Password Alanını Doldurunuz", button: "Tamam")
            return
        }
        
        self.checkUserOnFirebase(userName: email , password: password) { (isValid,user) in
            if !isValid{
                 self.showDefaultAlert(title: "Hatalı Bilgi", message: "Email ve Passwordunuzun Dogru oldugunu Kontrol ediniz", button: "Tamam")
            }
        }
    }
   
    
    func checkUserOnFirebase(userName: String, password: String, completion: @escaping (Bool,User?)->()){
        Service.ds.FIR_AUTH.signIn(withEmail: userName, password: password, completion: { (user, error) in
            if user == nil {
                completion(false, User(id: "", email: "", fullname: "", workstartDate: "", isCaptain: false, password: "", imageurl: ""))
            }else{
                let usr = User(id: (user?.uid)!, email: (user?.email)!, fullname:"", workstartDate: "", isCaptain: false, password: "",imageurl : "")
                self.getUser(user: usr)
            }
        })
    }
    func getUser(user : User)  {
        Service.ds.getUser(id: user.id) { (result, user) in
            if result {
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController")
                self.userInfo = User(id: user.id, email: user.email, fullname: user.fullname, workstartDate: user.workstartDate!, isCaptain: user.isCaptain, password: user.password, imageurl: user.imageUrl)
                
                self.setUserInfoOnUserDefaults()
                 return
                self.present(mainVC!, animated: true, completion: nil)
            }else {
                print("not saved database --> checkUserOnFirebase")
            }
        }
    }
    
    func setUserInfoOnUserDefaults(){
        UserDefaults.standard.set(self.userInfo.id, forKey: "userId")
        UserDefaults.standard.set(self.userInfo.imageUrl, forKey: "ImageUrl")
    }
    
    func loggedinBefore(){
        if UserDefaults.standard.value(forKey: "userId") != nil {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController")
            self.present(mainVC!, animated: true)
        }else {
            print("agaaa daha önce girmemişsinn")
        }

    }
}

