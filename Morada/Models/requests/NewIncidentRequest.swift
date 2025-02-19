//
//  NewIncidentRequest.swift
//  Morada
//
//  Created by MacBook Air on 18/02/25.
//

import Foundation

struct NewIncidentRequest: Codable {
    let user: String
    let classification: String
    let description: String
    let comments: String
    let status: String
    let date: String
    let uuidSuperAdmin: String
    let uuid: String
    let idAssigned: String
    let evidence: String
}
