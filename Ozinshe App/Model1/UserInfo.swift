//
//  UserInfo.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 18.10.2023.
//

import UIKit
import SwiftyJSON

class UserInfo {
    
    public var name: String = ""
    public var phoneNumber: String = ""
    public var birthDate: String = ""
    public var email: String = ""
    
    init() {
        
    }

    init(json: JSON) {
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["phoneNumber"].string {
            self.phoneNumber = temp
        }
        if let temp = json["birthDate"].string {
            self.birthDate = temp
        }
        if let temp = json["email"].string {
            self.email = temp
        }
    }
}
