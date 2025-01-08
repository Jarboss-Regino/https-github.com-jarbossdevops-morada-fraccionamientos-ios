//
//  ReservationsResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 21/10/24.
//

import Foundation

struct ReservationsResponse: Codable{
    let registros: [Reservations]
}

struct Reservations: Codable, Identifiable {
    var id: String
    var lugar: String
    var desde: String
    var hasta: String
    var persona: String
    var comentario: String
    var fecha: String
    var reservacion: String
    var estatus: Int
}



