//
//  EventResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 10/10/24.
//

import Foundation

struct Evento: Identifiable, Codable,CalendarEventProtocol {
    let id: String
    let user: String
    let persons: String
    let tittle: String
    let description: String
    let uuid: String
    let uuidSuperAdmin: String
    let idAssigned: AssignedID
    let v: Int
    let assigned: [String]
    let name: String
    let lastName: String
    let dateI: String
    let dateF: String
    var fechaEvent: Date?
    var formatDate: String?
    var realDate: String?
    
  
    

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case persons
        case tittle
        case description
        case uuid
        case uuidSuperAdmin
        case idAssigned
        case v = "__v"
        case assigned
        case name
        case lastName
        case dateI
        case dateF
       
    }
}


