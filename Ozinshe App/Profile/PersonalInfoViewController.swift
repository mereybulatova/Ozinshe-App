//
//  PersonalInfoViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 18.10.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var userInformation = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadPersonalInfo()

        saveButton.layer.cornerRadius = 12
        
        hideKeyboardWhenTappedAround()
        
        setData()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setData() {
        
        nameTextLabel.placeholder = userInformation.name
        emailLabel.text = userInformation.email
        phoneTextField.placeholder = userInformation.phoneNumber
        birthTextField.placeholder = userInformation.birthDate
        
    }
    
    
    func downloadPersonalInfo() {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        AF.request(Urls.GET_USER_PROFILE, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
  
                    if let array = json.array {
                        for item in array {
                            let userInform = UserInfo(json: item)
                            self.birthTextField.text = userInform.birthDate
                            self.nameTextLabel.text = userInform.name
                            self.emailLabel.text = userInform.email
                            self.phoneTextField.text = userInform.phoneNumber
                            self.setData()
                        }
                    } else {
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }
                } else {
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(sCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        self.setData()
        }

    @IBAction func saveInfoButton(_ sender: Any) {
              let updatedName = nameTextLabel.text ?? ""
              let updatedEmail = emailLabel.text ?? ""
              let updatedBirth = birthTextField.text ?? ""
              let updatedPhone = phoneTextField.text ?? ""
              
              updateUserInfo(updatedName: updatedName, updatedEmail: updatedEmail, updatedBirth: updatedBirth, updatedPhone: updatedPhone)
    }
    
    func updateUserInfo(updatedName: String, updatedEmail: String, updatedBirth: String, updatedPhone: String) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
               
               let parameters: [String: Any] = [
                   "name": updatedName,
                   "email": updatedEmail,
                   "phoneNumber": updatedPhone,
                   "birthDate": updatedBirth
               ]
               
               AF.request(Urls.UPLOAD_USER_INFO, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                   .responseData { response in
                       SVProgressHUD.dismiss()
                       var resultString = ""
                       if let data = response.data {
                           resultString = String(data: data, encoding: .utf8)!
                           print(resultString)
                       }
                       
                       if response.response?.statusCode == 200 {
                           print("User information updated successfully")
                           
                           self.updateUIWithUserInfo(updatedName: updatedName, updatedEmail: updatedEmail, updatedBirth: updatedBirth, updatedPhone: updatedPhone)
                       } else {
                           let errorString = "CONNECTION_ERROR".localized() + " \(response.response?.statusCode ?? -1) \(resultString)"
                           SVProgressHUD.showError(withStatus: errorString)
                       }
                   }
        self.setData()
    }
    
    func updateUIWithUserInfo(updatedName: String, updatedEmail: String, updatedBirth: String, updatedPhone: String) {
           nameTextLabel.text = updatedName
           emailLabel.text = updatedEmail
           birthTextField.text = updatedBirth
           phoneTextField.text = updatedPhone
       }
}
