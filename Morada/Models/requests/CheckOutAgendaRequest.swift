//
//  CheckOutAgendaRequest.swift
//  Morada
//
//  Created by MacBook Air on 14/02/25.
//

import Foundation

struct CheckOutAgendaRequest: Codable{
    let id: String
    let status: String
    let dateF: String
    let dateI: String
    let uuid: String
    let idAssigned: String
}

