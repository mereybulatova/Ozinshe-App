//
//  ProfileViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 05.09.2023.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol {
    
    
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var userInfoButton: UIButton!
    @IBOutlet weak var changeInfoLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var darkModeLabel: UILabel!
    
    @IBOutlet weak var darkMode: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureViews()
    }
    
    func configureViews() {
        navigationItem.title = "PROFILE_TITLE".localized()
        userInfoButton.setTitle("USER_INFO_BUTTON".localized(), for: .normal)
        changeInfoLabel.text = "USER_INFO_EDIT_LABEL".localized()
        changePasswordButton.setTitle("CHANGE_PASSWORD_BUTTON".localized(), for: .normal)
        darkModeLabel.text = "DARK_MODE_LABEL".localized()
        myProfileLabel.text = "MY_PROFILE".localized()
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)
        
        if Localize.currentLanguage() == "ru" {
            languageLabel.text = "Русский"
        }
        if Localize.currentLanguage() == "kk" {
            languageLabel.text = "Қазақша"
        }
        if Localize.currentLanguage() == "en" {
            languageLabel.text = "English"
        }
    }
    
    
    
    @IBAction func languageShowButton(_ sender: Any) {
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        
        languageVC.modalPresentationStyle = .overFullScreen
        
        languageVC.delegate = self
        
        present(languageVC, animated: true, completion: nil)
    }
    
    
    @IBAction func logOutShowButton(_ sender: Any) {
        let logOutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
        
        logOutVC.modalPresentationStyle = .overFullScreen
        
        self.present(logOutVC, animated: true, completion: nil)
    }
    
    @IBAction func userInfoButton(_ sender: Any) {
        let personalInfo = storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
        navigationItem.title = ""
        
        navigationController?.show(personalInfo, sender: self)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let passwordChange = storyboard?.instantiateViewController(withIdentifier: "EditPasswordViewController") as! EditPasswordViewController
        
        navigationItem.title = ""
        
        navigationController?.show(passwordChange, sender: self)
    }
    func languageDidChande() {
        configureViews()
    }
    
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}
