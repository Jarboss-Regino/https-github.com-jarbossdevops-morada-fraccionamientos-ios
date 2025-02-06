//
//  ResidentResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 30/09/24.
//

import Foundation

struct ResidentResponse: Codable, Identifiable {
    let id: String
    let name: String
    let lastName: String
    let address: String
    let phone: String
    let access: String
    let email: String
    let idAssigned: String
    let assigned: String
    let uuidSuperAdmin: String
    let uuid: String
    let username: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case lastName
        case address
        case phone
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


