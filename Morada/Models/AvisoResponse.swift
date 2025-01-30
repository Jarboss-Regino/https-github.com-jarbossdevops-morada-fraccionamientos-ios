//
//  AvisoResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 31/10/24.
//

import Foundation

struct AvisoResponse: Codable, Identifiable{
    let id: String
    let userName: String
    let description: String
    let place: String
    let adjunto: String
    let uuid: String
    let uuidSuperAdmin: String
    let idAssigned: AssignedID
    let v: Int
    let assigned: AssignedValue
    let name: String
    let lastName: String
    let date: String
    let hour: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userName
        case description
        case place
        case adjunto
        case uuid
        case uuidSuperAdmin
        case idAssigned
        case v = "__v"
        case assigned
        case name
        case lastName
        case date
        case hour
    }
}



