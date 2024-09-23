//
//  LoginService.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation

// Modelo para representar la respuesta del servidor
struct LoginResponse: Codable {
    let token: String
    let userId: Int
}

// Definir un enum para manejar errores de la API
enum ApiError: Error {
    case invalidUrl
    case decodingError
    case serverError(String)
    case networkError(String)
}

class ApiService {
    // Función genérica para realizar solicitudes POST
    func post<T: Codable, U: Codable>(urlString: String, body: T) async throws -> U {
            // Asegurarse de que la URL es válida
            guard let url = URL(string: urlString) else {
                throw ApiError.invalidUrl
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var bodyData = Data()
            
            // Convertir el cuerpo en pares clave-valor
            if let dictionary = try? body.asDictionary() {
                for (key, value) in dictionary {
                    bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                    bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    bodyData.append("\(value)\r\n".data(using: .utf8)!)
                }
            }
            
            bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = bodyData

            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw ApiError.serverError("Error del servidor: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                return decodedResponse
            } catch {
                throw ApiError.decodingError
            }
        }
}

// Extensión para convertir Codable a diccionario
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any] else {
            throw ApiError.decodingError
        }
        return dictionary
    }
}
