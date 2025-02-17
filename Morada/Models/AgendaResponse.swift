//
//  AgendaResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 12/11/24.
//

import Foundation

struct AgendaResponse: Codable{
    let agenda: AgendaItem
}

struct AgendaItem: Codable, Identifiable{
    let id: String
        let name: String
        let visit: String
        let email: String
        let address: String
        let phone: String
        let typeVisit: String
        let dateI: String
        let evidence: String
        let status: String
        let uuid: String
        let uuidSuperAdmin: String
        let idAssigned: String
        let version: Int
        let dateF: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name, visit, email, address, phone, typeVisit, dateI, evidence, status, uuid, uuidSuperAdmin, idAssigned, dateF
            case version = "__v"
        }
}
