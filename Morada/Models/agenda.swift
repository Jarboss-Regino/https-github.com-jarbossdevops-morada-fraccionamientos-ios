//
//  CheckOutAgendaItem.swift
//  Morada
//
//  Created by MacBook Air on 13/02/25.
//

import Foundation

struct agenda: Codable{
    var id: String
    var name: String
    var visit: String
    var email: String
    var address: String
    var phone: String
    var typeVisit: String
    var dateI: String
    var evidence: String
    var status: Int
    var uuid: String
    var uuidSuperAdmin: String
    var idAssigned: String
    var v: Int
    var dateF: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case visit
        case email
        case address
        case phone
        case typeVisit
        case dateI
        case evidence
        case status
        case uuid
        case uuidSuperAdmin
        case idAssigned
        case v = "__v"
        case dateF
    }
}
