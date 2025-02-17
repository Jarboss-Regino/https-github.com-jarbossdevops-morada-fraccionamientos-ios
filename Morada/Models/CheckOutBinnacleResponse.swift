//
//  CheckOutBinnacleResponse.swift
//  Morada
//
//  Created by MacBook Air on 17/02/25.
//

import Foundation

struct CheckOutBinnacleResponse: Codable{
    let agenda: response
}

struct response: Codable{
    var id: String
    var name: String
    var issue: String
    var visit: String
    var address: String
    var phone: String
    var typeVisit: String
    var dateI: String
    var evidence: [String]
    var status: String
    var uuid: String
    var uuidSuperAdmin: String
    var idAssigned: String
    var v: Int
    var dateF: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case issue
        case visit
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
