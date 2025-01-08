//
//  IncidentsResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 17/10/24.
//

import Foundation

struct IncidentsResponse: Codable{
    var registros: [Incidents]
}

struct Incidents: Codable, Identifiable {
    var id: String
    var id_usuario: String
    var clasificacion: String
    var descripcion: String
    var evidencia: String
    var comentarios: String
    var statuss: String
    var fecha: String
    var estatus: Int
              
}
