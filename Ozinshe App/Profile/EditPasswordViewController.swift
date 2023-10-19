//
//  EditPasswordViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 18.10.2023.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class EditPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var returnPasswordTextField: UITextField!
    @IBOutlet weak var saveChanges: UIButton!
    @IBOutlet weak var changePasswordLable: UILabel!
    @IBOutlet weak var repeatPsswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.layer.cornerRadius = 12
        returnPasswordTextField.layer.cornerRadius = 12
        saveChanges.layer.cornerRadius = 12
        configureViews()
    }
    
    func configureViews() {
        
        passwordTextField.placeholder = "USER_PASSWORD_CHANGE".localized()
        returnPasswordTextField.placeholder = "USER_PASSWORD_CHANGE".localized()
        saveChanges.setTitle("US_INFO_SAVE_BUTTON".localized(), for: .normal)
        changePasswordLable.text = "CHANGE_PASSWORD_LABEL".localized()
        repeatPsswordLabel.text = "REPEAT_PASSWORD_LABEL".localized()
        navigationItem.title = "CHANGE_PASSWORD_NAVIGATION".localized()
    }
    
    @IBAction func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func repeatShowPassword(_ sender: Any) {
        returnPasswordTextField.isSecureTextEntry = !returnPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func saveChangesButton(_ sender: Any) {
        let newPassword = passwordTextField.text!
        let repeatPassword = returnPasswordTextField.text!
        
        //validasia
        if  newPassword != repeatPassword {
            SVProgressHUD.showError(withStatus: "Пароли должны совпадать!")
            return
        }
        SVProgressHUD.show()
//        if newPassword == repeatPassword {
//            SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
            let parameters = ["password": newPassword]
            AF.request(Urls.CHANGE_PASSWORD, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                SVProgressHUD.dismiss()
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                    print(resultString)
                }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    if let token = json["accessToken"].string {
                        Storage.sharedInstance.accessToken = token
                        UserDefaults.standard.set(token, forKey: "accessToken")
                        self.popViewController()
                    } else {
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }
                } else {
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        }
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    }
   



/*
 import SwiftyJSON

 class EditPasswordViewController: UIViewController {
     
     
     @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var returnPasswordTextField: UITextField!
     @IBOutlet weak var saveChanges: UIButton!

     override func viewDidLoad() {
         super.viewDidLoad()
         
         passwordTextField.layer.cornerRadius = 12
         returnPasswordTextField.layer.cornerRadius = 12
         saveChanges.layer.cornerRadius = 12
     }
     
     @IBAction func showPassword(_ sender: Any) {
         passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
     }
     
     @IBAction func repeatShowPassword(_ sender: Any) {
         returnPasswordTextField.isSecureTextEntry = !returnPasswordTextField.isSecureTextEntry
     }
     
     @IBAction func saveChangesButton(_ sender: Any) {
         let newPassword = passwordTextField.text!
         let repeatPassword = returnPasswordTextField.text!
         
         if newPassword == repeatPassword {
             SVProgressHUD.show()
             let parameters = ["password": newPassword]
             AF.request(Urls.CHANGE_PASSWORD, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                 SVProgressHUD.dismiss()
                 var resultString = ""
                 if let data = response.data {
                     resultString = String(data: data, encoding: .utf8)!
                     print(resultString)
                 }
                 if response.response?.statusCode == 200 {
                     let json = JSON(response.data!)
                     print("JSON: \(json)")
                     if let token = json["accessToken"].string {
                         Storage.sharedInstance.accessToken = token
                         UserDefaults.standard.set(token, forKey: "accessToken")
                         self.popViewController()
                     } else {
                         SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                     }
                 } else {
                     var ErrorString = "CONNECTION_ERROR".localized()
                     if let sCode = response.response?.statusCode {
                         ErrorString = ErrorString + "\(sCode)"
                     }
                     ErrorString = ErrorString + "\(resultString)"
                     SVProgressHUD.showError(withStatus: "\(ErrorString)")
                 }
             }
         }
     }
     func popViewController() {
         navigationController?.popViewController(animated: true)
     }
 }
 */
