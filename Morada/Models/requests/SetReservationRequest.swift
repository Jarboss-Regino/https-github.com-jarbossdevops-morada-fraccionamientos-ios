//
//  SetReservationRequest.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 22/10/24.
//

import Foundation

struct SetReservationRequest: Codable {
    let placeReservation: String
    let hourI: String
    let hourF: String
    let persons: String
    let comments: String
    let personReservation: String
    let date: String
    let uuidSuperAdmin: String
    let uuid: String
    let idAssigned: String
}


