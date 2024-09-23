//
//  LoginDto.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation

struct LoginDto: Codable{
    let id: String?
    let nombre: String?  // id_usuario en el JSON
    let fecha: String?
    let tipo: Int?
    let idCliente: String?
    let nomCliente: String?
    let estatus: String
    let log: String?
        
    
}
