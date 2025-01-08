//
//  CheckOutResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 07/10/24.
//

import Foundation

struct CheckOutResponse: Codable {
    var registros: [Registro]
        var status: String
        var tipo: String?
        var total: Int?
        var sin_llegar: Int?
        var dentro: Int?
        var fuera: Int?
}

struct Registro: Codable, Identifiable {
    var id: String
    var estatus: Int
    var nombre: String
    var domicilio: String
    var numero: String
    var visita_a: String?
    var tipovis: String
    var idresidente: String?
    var residente: String?
    var correo: String?
    var fecha: String
    var hora: String
    var entrada: String
    var salida: String
    var evidencia: String?
    var tabla: String
}

