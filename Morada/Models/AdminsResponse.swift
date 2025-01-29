//
//  AdminsResponse.swift
//  Morada
//
//  Created by MacBook Air on 27/01/25.
//

import Foundation

struct AdminsResponse:Codable,Identifiable{
    let id: String
    let name: String
    let lastName: String
    let identityNumber: String
    let access: String
    let email: String
    let idAssigned: AssignedID
    let assigned: [String]
    let uuidSuperAdmin: String
    let uuid: String
    let username: String
    let v: Int
    
    // Mapeo de claves personalizadas si es necesario
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case lastName
        case identityNumber
        case access
        case email
        case idAssigned
        case assigned
        case uuidSuperAdmin
        case uuid
        case username
        case v = "__v"
    }
}
