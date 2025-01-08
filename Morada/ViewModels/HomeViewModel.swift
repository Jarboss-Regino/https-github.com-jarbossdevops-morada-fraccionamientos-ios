//
//  HomeViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/09/24.
//

import Foundation

class HomeViewModel: ObservableObject{
    @Published var tipo: Int?
    @Published var tipoUsuario: String?
    
    init(){
        self.tipo = UserSession.shared.userResponse?.tipo
        if let tipo = tipo {
            let message = String(tipo)
            print(message)
        } else {
            print("El tipo es nil")
        }
        
        self.tipoUsuario = UserSession.shared.userData?.access
        if let tipoUsuario = tipoUsuario {
            print("Usuario: " + tipoUsuario )
        }else{
            print("error al obtener el tipo de usuario")
        }
    }
    
    
}
