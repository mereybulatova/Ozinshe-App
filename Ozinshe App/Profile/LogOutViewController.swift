//
//  LogOutViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 27.09.2023.
//

import UIKit

class LogOutViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var LogOutBackgroundView: UIView!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var NoLogOutButton: UIButton!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var LogOutLabel: UILabel!
    @IBOutlet weak var LogOUtQuestionLabel: UILabel!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configureView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    func configureView() {
        LogOutBackgroundView.layer.cornerRadius = 32
        LogOutBackgroundView.clipsToBounds = true
        LogOutBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.layer.cornerRadius = 3
    }
   
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.LogOutBackgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.LogOutBackgroundView.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: LogOutBackgroundView))! {
            return false
        }
        return true
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInNavigationController") as! UINavigationController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismissView()
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
