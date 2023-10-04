//
//  CategoryTableViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 03.10.2023.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class CategoryTableViewController: UITableViewController {
    
    var categoryID = 0
    
    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
        downloadMoviesByCategory()
    }
    
    func downloadMoviesByCategory() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        let parametres = ["categoryId": categoryID]
        
        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parametres, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if json["content"].exists() {
                    if let array = json["content"].array {
                        for item in array {
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                        self.tableView.reloadData()
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
}
