//
//  SignInViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 22.09.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViews()
    
        hideKeyboardWhenTappedAround()
        
    }
    
    func configureViews() {
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        signInButton.layer.cornerRadius = 12.0
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func TextFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func TextFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if let navigationController = self.navigationController {
            signUpButton.addTarget(self, action: #selector(signInButtonTap), for: .touchUpInside)
            navigationItem.title = ""
        }
    }
    
    @objc func signInButtonTap() {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.show(signUpViewController!, sender: self)
    }
    
    @IBAction func signIn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SVProgressHUD.show()
        
        let parameters = ["email": email, "password": password]
        
        AF.request(Urls.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
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
        }
    func startApp() {
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
}

