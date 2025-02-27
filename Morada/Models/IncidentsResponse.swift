//
//  IncidentsResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 17/10/24.
//

import Foundation

struct IncidentsResponse: Codable,Identifiable {
    let id: String
    let user: String
    let classification: String
    let description: String
    let evidence: String
    let comments: String
    let status: String
    let uuid: String
    let uuidSuperAdmin: String
    let idAssigned: AssignedID
    let v: Int
    let assigned: AssignedValue
    let name: String
    let lastName: String
    let date: String

    // Decodificar el campo `_id` como `id` y `__v` como `v`
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case classification
        case description
        case evidence
        case comments
        case status
        case uuid
        case uuidSuperAdmin
        case idAssigned
        case v = "__v"
        case assigned
        case name
        case lastName
        case date
    }
}
