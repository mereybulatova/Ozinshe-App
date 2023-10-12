//
//  MainMovies.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 11.10.2023.
//

import Foundation
import SwiftyJSON

class MainMovies {
    var categoryId = 0
    var categoryName = ""
    var movies: [Movie] = []
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["categoryId"].int {
            self.categoryId = temp
        }
        if let temp = json["categoryName"].string {
            self.categoryName = temp
        }
        if let array = json["movies"].array {
            for item in array {
                let temp = Movie(json: item)
                self.movies.append(temp) 
            }
        }
    }
}
