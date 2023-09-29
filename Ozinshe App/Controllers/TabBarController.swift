//
//  TabBarController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 02.09.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabImages()

        // Do any additional setup after loading the view.
    }
    
    //Делаем так, чтобы наши кнопки на Tab Bar правильно закрашивались в нужный цвет
    
    func setTabImages() {
        let homeSelectedImage = UIImage(named: "HomeSelected")!.withRenderingMode(.alwaysOriginal)
        
        let searchSelectedImage = UIImage(named: "SearchSelected")!.withRenderingMode(.alwaysOriginal)
        
        let favoriteSelectedImage = UIImage(named: "FavoriteSelected")!.withRenderingMode(.alwaysOriginal)
        
        let profileSelectedImage = UIImage(named: "ProfileSelected")!.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[0].selectedImage = homeSelectedImage
        tabBar.items?[1].selectedImage = searchSelectedImage
        tabBar.items?[2].selectedImage = favoriteSelectedImage
        tabBar.items?[3].selectedImage = profileSelectedImage
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
