//
//  UserSession.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 24/09/24.
//

import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession()
        
        private let isLoggedInKey = "isLoggedIn"
        private let userResponseKey = "userResponse"
        
        init() {}
        
        var isLoggedIn: Bool {
            get {
                return UserDefaults.standard.bool(forKey: isLoggedInKey)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: isLoggedInKey)
            }
        }
        
        var userResponse: LoginDto? {
            get {
                        if let data = UserDefaults.standard.data(forKey: userResponseKey) {
                            do {
                                return try JSONDecoder().decode(LoginDto.self, from: data)
                            } catch {
                                print("Error al decodificar el LoginDto: \(error)")
                                return nil
                            }
                        }
                        return nil
                    }
                    set {
                        if let userResponse = newValue {
                            do {
                                let data = try JSONEncoder().encode(userResponse)
                                UserDefaults.standard.set(data, forKey: userResponseKey)
                            } catch {
                                print("Error al codificar el LoginDto: \(error)")
                            }
                        } else {
                            UserDefaults.standard.removeObject(forKey: userResponseKey)
                        }
                    }
        }
        
        func saveLoginData(userResponse: LoginDto)  {
            
            self.userResponse = userResponse
            self.isLoggedIn = true
            print("Datos guardados correctamente...")
        }
        
        func logout() {
            self.userResponse = nil
            self.isLoggedIn = false
            print("Datos borrados correctamente...")
        }
}
