//
//  ProfileViewController.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import UIKit
import Photos

class AddCoWorkerViewController: BaseTabbarViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var fullNameTextField : UITextField!
    @IBOutlet weak var jobTitleTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    
    var imageIsSelected : Bool = false
    var tempImage = UIImage()
    var tempDownloadUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func prepareViews()  {
        imageView.image = UIImage(named: "PlaceHolderImage")!
        fullNameTextField.text = nil
        jobTitleTextField.text = nil
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleProfileImageViewSelection)))
    }
    
    @objc  func handleProfileImageViewSelection(){
        PHPhotoLibrary.requestAuthorization { (status : PHAuthorizationStatus) in
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    func uploadProfileImageData(userId : String)  {
        if(imageIsSelected){
            let imageName = NSUUID().uuidString
            let storageRef = DB_STORAGEBASE.child("ProfileImages").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.tempImage, 0.5){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print("Onur : \(error.debugDescription)")
                        return
                    }
                    if let imageDownloadURL = metadata?.downloadURL()?.absoluteString{
                        Service.ds.REF_USERS.child(userId).updateChildValues(["ImageUrl":imageDownloadURL])
                        self.tempDownloadUrl = imageDownloadURL
                    }
                })
            }
            
        }
    }
    
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectedImageFromPicker = editedImage
            imageIsSelected = true
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImageFromPicker = originalImage
            imageIsSelected = true
        }
        if let selectedImage = selectedImageFromPicker {
            tempImage = selectedImage
            self.imageView = circleStrokeImage(image: selectedImage, highlightedImage: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Onur: Canceled")
        imageIsSelected = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createCoWorkerPressed(_ sender : UIButton){
        guard let email = self.emailTextField.text , !email.isEmpty else {
            self.showDefaultAlert(title: "Warning !", message: "Please Fill Email Area ", button: "Okey")
            return
        }
        guard let password  = self.passwordTextField.text , !password.isEmpty else {
            self.showDefaultAlert(title: "Warning !", message: "Please Fill Password Area", button: "Okey")
            return
        }
        guard let fullname = self.fullNameTextField.text , !fullname.isEmpty else {
            self.showDefaultAlert(title: "Warning !", message: "Please Fill Fullname Area ", button: "Okey")
            return
        }
        guard let jobtitle  = self.jobTitleTextField.text , !jobtitle.isEmpty else {
            self.showDefaultAlert(title: "Warning !", message: "Please Fill Job Title Area", button: "Okey")
            return
        }
        
        let dict : Dictionary<String, AnyObject> = ["Email": email as AnyObject,"Password" : password as AnyObject ,"FullName" : fullname as AnyObject , "JobTitle" : jobtitle as AnyObject,"ImageUrl" : "" as AnyObject, "IsCaptain": false as AnyObject,"WorkStartDate" : Date().toString() as AnyObject]
        Service.ds.createFirebaseUser(userData: dict) { (error) in
            if !error{
                self.showDefaultAlert(title: "Warning !", message: "Already in Use Data", button: "Okey")
            }else{
                self.showDefaultAlert(title: "Registiration Complete", message: "Another Member to Celebrate !", button: "Okey", action: { (action) in
                    print("okki Doki")
                })
            }
        }
    
    }

}
