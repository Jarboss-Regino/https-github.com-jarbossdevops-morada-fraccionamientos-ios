//
//  NewEventRequest.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 14/10/24.
//

import Foundation

struct NewEventRequest: Codable{
    let user: String
    let dateI: String
    let dateF: String
    let persons: String
    let tittle: String
    let description: String
    let uuidSuperAdmin: String
    let uuid: String
    let idAssigned: String
}
