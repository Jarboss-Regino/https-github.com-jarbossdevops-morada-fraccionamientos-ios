//
//  UserModel.swift
//  Morada
//
//  Created by MacBook Air on 23/09/24.
//

import Foundation
import SwiftData

@Model
class UserModel{
    var name: String?
    var isLogged: Bool
    
    init(name: String? = nil, isLogged: Bool) {
        self.name = name
        self.isLogged = isLogged
    }
}
