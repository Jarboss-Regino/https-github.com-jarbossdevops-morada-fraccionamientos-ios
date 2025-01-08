//
//  CustomRouter.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/11/24.
//

import Foundation
import SwiftUI

final class CustomRouter : ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case login
        case signup
        case recoveryPass
        case home
        
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        
        navPath.append(destination)
    }
    
    func replaceStack(with destination: Destination) {
        navPath = NavigationPath() // Limpia el stack actual
        navPath.append(destination) // Agrega el nuevo destino
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        //guard !navPath.isEmpty else { return }
        navPath.removeLast(navPath.count)
    }
}
