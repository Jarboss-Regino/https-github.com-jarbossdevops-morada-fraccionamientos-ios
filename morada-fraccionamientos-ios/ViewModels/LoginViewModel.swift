//
//  LoginViewModel.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation

struct LoginRequest: Codable {
    let source1: String
    let source2: String
}

struct EmailRequest: Codable {
    let source1: String
}

final class LoginViewModel: ObservableObject{
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loginSuccess: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var showError :Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var recoverEmail: String = ""
    
    
    // RECOVERY EMAIL VARIABLES
    @Published var errorEmailMessage: String = ""
    @Published var showEmailError: Bool = false
    @Published var isLoadingEmailSend: Bool = false
    @Published var succesMessage: String = ""
    @Published var showMessage:  Bool = false
    
    
    private let apiService = ApiService()
    
    
    func doLogin() async {
        if self.username.isEmpty || self.password.isEmpty {
            DispatchQueue.main.async {
                self.errorMessage = "Por favor, llene todos los campos"
                self.showError = true
            }
            
        } else {
            
            self.isLoading = true
            
            let body = LoginRequest(source1: self.username, source2: self.password)
            do {
                
                // Llamada asíncrona a la función post
                let response: LoginDto = try await apiService.post(urlString: ApiEndpoints.loginUrl, body: body)
                
                // Manejar la respuesta en el hilo principal
                DispatchQueue.main.async {
                    self.isLoading = false
                    if response.idCliente == nil {
                        self.errorMessage = "Usuario no vinculado a ningún fraccionamiento"
                        self.showError = true
                    } else {
                        self.errorMessage = ""
                        self.showError = false
                        self.loginSuccess = true
                    }
                }
            } catch let error as ApiError {
                // Manejar errores específicos de la API
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Error: \(error)"
                    self.showError = true
                }
            } catch {
                // Manejar errores genéricos
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Ocurrió un error inesperado"
                    self.showError = true
                }
            }
        }
        
        
    }
    
    func sendEmail() async {
        if self.recoverEmail.isEmpty {
            DispatchQueue.main.async {
                self.errorEmailMessage = "Por favor, llene todos los campos"
                self.showEmailError = true
                self.showMessage = false
                return
            }
            
        }
        
        self.isLoadingEmailSend = true
        let body = EmailRequest(source1: self.recoverEmail)

        do {
            // Llamada asíncrona a la función post
            let response: EmailResponse = try await apiService.post(urlString: ApiEndpoints.emailUrl, body: body)
            
            DispatchQueue.main.async {
                self.isLoadingEmailSend = false
                
                if response.enviado?.status == "ok" {
                    self.showEmailError = false
                    self.succesMessage = "El correo se envió correctamente"
                    self.showMessage = true
                    self.recoverEmail = ""
                } else {
                    self.showMessage = false
                    self.errorEmailMessage = "Ocurrió un error al enviar el correo"
                    self.showEmailError = true
                }
            }
        } catch let error as ApiError {
            DispatchQueue.main.async {
                self.isLoadingEmailSend = false
                self.errorEmailMessage = "Error: \(error)"
                self.showEmailError = true
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoadingEmailSend = false
                self.errorEmailMessage = "Error desconocido"
                self.showEmailError = true
            }
        }
    }
    
}

