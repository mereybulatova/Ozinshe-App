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
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       configureViews()
    }
    
    func configureViews() {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
