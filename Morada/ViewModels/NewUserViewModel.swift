//
//  NewUserViewModel.swift
//  Morada
//
//  Created by MacBook Air on 20/09/24.
//

import Foundation


struct newUserRequest: Codable{
    let source1: String
    let source2: String
    let source3: String
    let source4: String
}

final class NewUserViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPass: String = ""
    
    @Published var messageSuccess: String = ""
    @Published var showMessageSuccess: Bool = false
    
    @Published var errorMessageEmail: String = ""
    @Published var showErrorEmail: Bool = false
    @Published var errorPassword: String = ""
    @Published var showErrorpass: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var showError = false
    @Published var isLoading = false
    
    private let apiService = ApiService()
   
    func createNewAccount() async {
        if self.name.isEmpty || self.email.isEmpty ||
            self.password.isEmpty || self.confirmPass.isEmpty{
            
            self.errorMessage = "Por favor, llene todos los campos"
            self.showError = true
            return
        }
        self.showError = false
        
        if !isValidEmail(self.email){
            self.errorMessageEmail = "Por favor, Use un correo válido"
            self.showErrorEmail = true
            
            return
        }
        self.showErrorEmail = false
        
        if !self.password.elementsEqual(self.confirmPass){
            self.errorPassword = "Las contraseñas no coinciden"
            self.showErrorpass = true
           

            return
        }
        
        
        
        self.showErrorpass = false
        self.isLoading = true
        let body = newUserRequest(source1: self.name, source2: self.email, source3: self.password, source4: self.confirmPass)
        
        do{
            
            
            let response: NewUserResponse = try await apiService.post(urlString: ApiEndpoints.creaateUserUrl, body: body)
            
            DispatchQueue.main.async{
                self.isLoading = false
                if response.estatus == "ok"{
                    self.messageSuccess = "Usuario registrado"
                    self.showMessageSuccess = true
                    
                    self.name = ""
                    self.email = ""
                    self.password = ""
                    self.confirmPass = ""
                    
                }else{
                    
                }
            }
            
        }catch let error as ApiError {
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
