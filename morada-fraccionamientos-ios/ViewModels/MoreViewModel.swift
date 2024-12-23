//
//  TestViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/09/24.
//

import Foundation

class TestViewModel: ObservableObject{
    
    @Published var tipo: Int?
    
    init(){
        self.tipo = UserSession.shared.userResponse?.tipo
        if let tipo = tipo {
            let message = String(tipo)
            print(message)
        } else {
            print("El tipo es nil")
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            UserSession.shared.logout()
        }
        
    }
}
