//
//  NewReservationResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 23/10/24.
//

import Foundation

struct NewReservationResponse: Codable{
    let estatus: String
    let reservacionesId: String?
    let reservacionesFecha: String?
}

