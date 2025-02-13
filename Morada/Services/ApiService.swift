//
//  LoginService.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation
import UIKit



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
    
    // Función genérica para realizar solicitudes POST con JSON
        func postJson<T: Codable, U: Codable>(urlString: String, body: T) async throws -> U {
            // Asegurarse de que la URL es válida
            guard let url = URL(string: urlString) else {
                throw ApiError.invalidUrl
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                // Codificar el cuerpo como JSON
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
            } catch {
                throw ApiError.decodingError
            }

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw ApiError.serverError("Error del servidor: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📩 Respuesta del servidor: \(jsonString)")
            } else {
                print("❌ No se pudo convertir la respuesta en String")
            }
        
            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                return decodedResponse
            } catch {
                throw ApiError.decodingError
            }
        }
    
    // Función genérica para realizar solicitudes GET
        func get<T: Codable>(urlString: String) async throws -> T {
            // Asegurar que la URL es válida
            guard let url = URL(string: urlString) else {
                throw ApiError.invalidUrl
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Realizar la solicitud
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw ApiError.serverError("Error del servidor: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
            
            // Decodificar respuesta
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw ApiError.decodingError
            }
        }
    
    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verificar el código de estado HTTP
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw ApiError.serverError("Error del servidor: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        }
        
        // Intentar convertir a UIImage
        guard let image = UIImage(data: data) else {
            throw ApiError.decodingError
        }
        
        return image
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
