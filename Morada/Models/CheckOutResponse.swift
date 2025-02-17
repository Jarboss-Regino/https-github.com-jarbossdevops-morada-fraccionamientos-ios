//
//  CheckOutResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 07/10/24.
//

import Foundation

struct CheckOutResponse: Codable {
    let id: String
    let name: String
    let issue: String
    let visit: String
    let address: String
    let phone: String
    let typeVisit: String
    let evidence: [String]
    let status: String
    let uuid: String
    let uuidSuperAdmin: String
    let idAssigned: AssignedID
    let v: Int
    let assigned: AssignedValue
    let lastName: String
    let dateI: String
    let dateF: String?
    let dateFormated: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, issue, visit, address, phone, typeVisit, evidence, status
        case uuid, uuidSuperAdmin, idAssigned, v = "__v", assigned, lastName, dateI, dateF, dateFormated
    }
}

