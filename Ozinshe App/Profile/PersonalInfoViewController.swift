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
import Localize_Swift

class PersonalInfoViewController: UIViewController {
    var userID: Int?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadPersonalInfo()
        saveButton.layer.cornerRadius = 12
        hideKeyboardWhenTappedAround()
        configureViews()
    }
    
    func configureViews() {
        navigationItem.title = "USER_INFO_NAVIGATION".localized()
        nameLabel.text = "USER_INFO_NAME_LABEL".localized()
        nameTextField.placeholder = "USER_INFO_NAME_TEXT_FIELD".localized()
        phoneLabel.text = "US_INFO_PHONE_LABEL".localized()
        birthLabel.text = "US_INFO_BIRTH_LABEL".localized()
        saveButton.setTitle("US_INFO_SAVE_BUTTON".localized(), for: .normal)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    func downloadPersonalInfo() {
        SVProgressHUD.show()
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        AF.request(Urls.UPLOAD_USER_INFO, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                let name = json ["name"]
                let email = json ["user"]["email"]
                let phoneNumber = json["phoneNumber"]
                let birthDate = json ["birthDate"]
                self.userID = json ["id"].int
                self.nameTextField.text = name.stringValue
                self.emailTextField.text = email.stringValue
                self.phoneTextField.text = phoneNumber.stringValue
                self.birthTextField.text = birthDate.stringValue
            } else {
                SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())

                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    @IBAction func saveInfoButton(_ sender: Any) {
        let updatedName = nameTextField.text ?? ""
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
            "birthDate": updatedBirth,
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
                    
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: resultString)
    
                    let errorString = "CONNECTION_ERROR".localized() + " \(response.response?.statusCode ?? -1) \(resultString)"
                    SVProgressHUD.showError(withStatus: errorString)
                }
            }
    }
}

