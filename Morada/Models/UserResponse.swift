//
//  UserResponse.swift
//  Morada
//
//  Created by MacBook Air on 07/01/25.
//

import Foundation

struct UserResponse: Codable {
    let data: [UserDetails]
}

struct UserDetails: Codable {
    let access: String
        let email: String
        let fullName: String
        let mode: String
        let uuid: String
        let uuidSuperAdmin: String
        let password: String
        let status: String
        let idAssigned: AssignedID
        let username: String
    }

    enum AssignedID: Codable {
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
                    AssignedID.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected a string or an array for `idAssigned`."
                    )
                )
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case .string(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            }
        }
        
        func getStringValue() -> String {
            switch self {
            case .string(let value):
                return value
            case .array(let values):
                return values.joined(separator: ",") // Combina en un string, ajusta según tu necesidad
            }
        }
    }
