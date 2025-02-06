//
//  SetVisitRequest.swift
//  Morada
//
//  Created by MacBook Air on 05/02/25.
//

import Foundation

struct SetVisitRequest: Codable{
    let name: String
    let issue: String
    let visit: String
    let address: String
    let phone: String
    let typeVisit: String
    let dateI: String
    let uuidSuperAdmin: String
    let uuid: String
    let idAssigned: String
    let evidence: String
}
