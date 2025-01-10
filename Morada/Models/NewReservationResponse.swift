//
//  NewReservationResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 23/10/24.
//

import Foundation

struct NewReservationResponse: Codable{
    let message: String
    let error: String?
    let statusCode: Int?
}

