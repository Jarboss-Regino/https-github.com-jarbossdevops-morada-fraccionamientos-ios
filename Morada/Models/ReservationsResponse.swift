//
//  ReservationsResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 21/10/24.
//

import Foundation

struct ReservationsResponse: Codable, Identifiable {
    let id: String
    let placeReservation: String
    let hourI: String
    let hourF: String
    let persons: String
    let comments: String
    let personReservation: String
    let uuid: String
    let uuidSuperAdmin: String
    let idAssigned: AssignedID
    let idResident: String?
    let idAdministrative: String?
    let idOperative: String?
    let v: Int
    let assigned: [String]
    let name: String
    let lastName: String
    let date: String
    
    // Decodificar el campo `_id` como `id`
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case placeReservation
        case hourI
        case hourF
        case persons
        case comments
        case personReservation
        case uuid
        case uuidSuperAdmin
        case idAssigned
        case idResident
        case idAdministrative
        case idOperative
        case v = "__v"
        case assigned
        case name
        case lastName
        case date
    }
}



