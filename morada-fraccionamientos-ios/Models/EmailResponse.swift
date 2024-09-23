//
//  EmailResponse.swift
//  Morada
//
//  Created by MacBook Air on 20/09/24.
//

import Foundation

struct EmailResponse: Codable {
    let estatus: String
    let indexId: String?
    let indexFecha: String?
    let enviado: Enviado?
}

struct Enviado: Codable {
    let log: [String]
    let status: String
}
