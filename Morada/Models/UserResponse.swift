//
//  UserResponse.swift
//  Morada
//
//  Created by MacBook Air on 07/01/25.
//

import Foundation

struct UserResponse: Codable {
    let data: [UserDetails]
}

struct UserDetails: Codable {
    let access: String
    let email: String
    let mode: String
    let uuid: String
    let password: String
    let uuidSuperAdmin: String
    let fullName: String
    let status: String
    let idAssigned: String
}
