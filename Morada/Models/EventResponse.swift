//
//  EventResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 10/10/24.
//

import Foundation

struct Evento: Identifiable, Codable,CalendarEventProtocol {
    var id: String
    var idUsuario: String?
    var fechaEvento: String
    var horaInicio: String
    var horaFin: String
    var personas: Int
    var comentarios: String
    var fecha: String
    var estatus: Int
    var fechaEvent: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case idUsuario = "id_usuario"
        case fechaEvento = "fechaevento"
        case horaInicio = "horainicio"
        case horaFin = "horafin"
        case personas
        case comentarios
        case fecha
        case estatus
    }
}

struct EventResponse: Codable {
    let registros: [Evento]
}
