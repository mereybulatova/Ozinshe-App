//
//  SignUpViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 26.09.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var repeatSignUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
      
        hideKeyboardWhenTappedAround()
    }
        
    
    func configureViews() {
        signUpEmailTextField.layer.cornerRadius = 12.0
        signUpEmailTextField.layer.borderWidth = 1.0
        signUpEmailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        signUpPasswordTextField.layer.cornerRadius = 12.0
        signUpPasswordTextField.layer.borderWidth = 1.0
        signUpPasswordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        repeatSignUpPasswordTextField.layer.cornerRadius = 12.0
        repeatSignUpPasswordTextField.layer.borderWidth = 1.0
        repeatSignUpPasswordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        signUpButton.layer.cornerRadius = 12.0
        signUpButton.tintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00)
        
        signInButton.tintColor = UIColor(red: 0.70, green: 0.46, blue: 0.97, alpha: 1.00)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        if let navigationController = self.navigationController {
            signInButton.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
            navigationItem.title = ""
        }
        
    }
    
    @objc func nextButtonTouched() {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
        navigationController?.show(signInViewController!, sender: self)
    }
    
    @IBAction func textFieldEditingBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func textFieldEditingEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func showPassword(_ sender: Any) {
        signUpPasswordTextField.isSecureTextEntry = !signUpPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func repeatShowPassword(_ sender: Any) {
        repeatSignUpPasswordTextField.isSecureTextEntry = !repeatSignUpPasswordTextField.isSecureTextEntry
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        let signUpEmail = signUpEmailTextField.text!
        let signUpPassword = signUpPasswordTextField.text!
        let confirmPassword = repeatSignUpPasswordTextField.text!
        
        if signUpPassword == confirmPassword {
            
                        SVProgressHUD.show()
            
                        let parameters = ["email": signUpEmail, "password": signUpPassword]
            
                        AF.request(Urls.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
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
                                    self.startApp()
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
            print("Registration is successful")
        } else {
            showAlert(message: "Try again")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func startApp() {
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
    
}
