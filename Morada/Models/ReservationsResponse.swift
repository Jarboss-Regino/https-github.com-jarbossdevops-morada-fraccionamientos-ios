//
//  ReservationsResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 21/10/24.
//

import Foundation

struct ReservationsResponse: Codable, Identifiable {
    let id: String
    let placeReservation: String
    let hourI: String
    let hourF: String
    let persons: String
    let comments: String
    let personReservation: String
    let uuid: String
    let uuidSuperAdmin: String
    let idAssigned: AssignedID
    let idResident: String?
    let idAdministrative: String?
    let idOperative: String?
    let v: Int
    let assigned: AssignedValue
    let name: String
    let lastName: String
    let date: String
    
    // Decodificar el campo `_id` como `id`
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case placeReservation
        case hourI
        case hourF
        case persons
        case comments
        case personReservation
        case uuid
        case uuidSuperAdmin
        case idAssigned
        case idResident
        case idAdministrative
        case idOperative
        case v = "__v"
        case assigned
        case name
        case lastName
        case date
    }
    
   
}
enum AssignedValue: Codable {
    case string(String)
    case array([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            throw DecodingError.typeMismatch(
                AssignedValue.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected a String or an Array of Strings for `assigned`."
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let value):
            try container.encode(value)
        case .array(let values):
            try container.encode(values)
        }
    }
    
    /// Convierte `AssignedValue` en un array de strings
    func toArray() -> [String] {
        switch self {
        case .string(let value):
            return [value]
        case .array(let values):
            return values
        }
    }
}



