//
//  LoginViewModel.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation



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
    
    
    @Published var isLoggedIn = false
    
    private let apiService = ApiService()
    
    @MainActor
    func doLogin() async {
        if username.isEmpty || password.isEmpty {
            
            self.errorMessage = "Por favor, llene todos los campos"
            self.showError = true
            
            
        } else {
            
            self.isLoading = true
            let tempEmail = self.username.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let body = LoginRequest(user: username.trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines))
            
            do {
                
                // Llamada asíncrona a la función post
                let response: LoginResponse = try await apiService.postJson(urlString: ApiEndpoints.loginUrl, body: body)
                print("URL"+ApiEndpoints.loginUrl)
                // Manejar la respuesta en el hilo principal
                
                    
                if response.status == 200 {
                    //UserSession.shared.saveLoginData(userResponse: response)
                    self.errorMessage = ""
                    self.showError = false
                    //self.loginSuccess = true
                    self.isLoggedIn = true
                    self.username = ""
                    self.password = ""
                    print("Loggin exitoso")
                    
                    do {
                        let userDetails: UserResponse = try await apiService.get(urlString: ApiEndpoints.getDataUse(email: tempEmail))
                        print(userDetails)
                        // Guardar datos del usuario o manejar la respuesta
                        UserSession.shared.saveUserInfo(userResponse: userDetails.data.first!)
                        print("Datos del usuario obtenidos exitosamente")
                        self.loginSuccess = true
                    } catch {
                        self.loginSuccess = false
                        self.errorMessage = "Error al obtener los datos del usuario"
                        self.showError = true
                    }
                } else {
                    
                    self.loginSuccess = false
                    self.errorMessage = "Usuario no vinculado a ningún fraccionamiento"
                    self.showError = true
                    
                    
                }
                self.isLoading = false
            } catch let error as ApiError {
                // Manejar errores específicos de la API
                
                self.isLoading = false
                self.errorMessage = "Error: \(error)"
                self.showError = true
                
            } catch {
                // Manejar errores genéricos
                
                self.isLoading = false
                self.errorMessage = "Ocurrió un error inesperado"
                self.showError = true
                
            }
        }
        
        
    }
    
    
    
    func saveData(response: LoginDto){
        // Guardar el nombre y el estado de sesión en UserDefaults
        UserDefaults.standard.set(self.username, forKey: "username")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        print("datos guardados correctamente")
    }
    
    @MainActor
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
    
    // Función para cerrar sesión
        func logout() {
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    func LoggedIn() -> Bool {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: "username")
    }
    
}

