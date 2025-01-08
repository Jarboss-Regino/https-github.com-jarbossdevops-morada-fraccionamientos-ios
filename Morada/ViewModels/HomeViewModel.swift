//
//  HomeViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/09/24.
//

import Foundation

class HomeViewModel: ObservableObject{
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
    
    
}
