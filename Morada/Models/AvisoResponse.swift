//
//  AvisoResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 31/10/24.
//

import Foundation

struct AvisoResponse: Codable{
    var registros: [Aviso]
}

struct Aviso: Identifiable, Codable,CalendarEventProtocol{
    var id: String
    var nombre: String
    var contenido: String
    var fecha: String
    var lugar: String
    var adjunto: String
    var hora: String
    var estatus: Int
    var fechaEvent: Date?
}

