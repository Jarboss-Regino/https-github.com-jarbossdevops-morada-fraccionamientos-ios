//
//  AgendaResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 12/11/24.
//

import Foundation

struct AgendaResponse: Codable{
    let registros: [AgendaItem]
}

struct AgendaItem: Codable, Identifiable{
    var id: String
    var tipovis: String
    var residente: String
    var nombre: String
    var correo: String
    var domicilio: String
    var numero: String
    var fecha: String
    var hora: String
    var estatus: Int
    var entrada: String
    var salida: String
    var tabla: String
}
