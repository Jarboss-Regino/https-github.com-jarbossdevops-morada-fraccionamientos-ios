//
//  VisitRequest.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 07/11/24.
//

import Foundation

struct VisitRequest: Codable{
    let name: String
    let email: String
    let visit: String
    let address: String
    let phone: String
    let typeVisit: String
    let dateI: String
    let uuidSuperAdmin: String
    let uuid: String
    let idAssigned: String
}

