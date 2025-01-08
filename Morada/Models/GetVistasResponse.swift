//
//  GetVistasResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 12/11/24.
//

import Foundation

struct GetVistasResponse: Codable{
    var registros: [DetailVisitas]
    var total_visitas: Int?
    var por_ingresar: Int?
    var ingresadas: Int?
    var fuera: Int?
    var status: String
    
    
    
}

struct DetailVisitas: Codable, Identifiable{
    var id: String
    var estatus: Int
    var residente: String?
    var nombre: String
    var correo: String?
    var domicilio: String
    var numero: String?
    var visita_a: String?
    var tipovis: String
    var fecha: String
    var hora: String
    var entrada: String
    var salida: String
    var evidencia: String?
    var tabla: String
   
}
//"id": "66cd09c58229a",
//            "estatus": 1,
//            "nombre": "Ups",
//            "domicilio": "Domicilio1",
//            "numero": "4821567899",
//            "visita_a": "Rogelio Elizondo",
//            "tipovis": "Empleado",
//            "fecha": "2024-08-26",
//            "hora": "17:03:00",
//            "entrada": "17:03:33",
//            "salida": "00:00:00",
//            "evidencia": "66cd09c5590ff_1.jpg,66cd09c5590ff_2.jpg",
//            "tabla": "1"


