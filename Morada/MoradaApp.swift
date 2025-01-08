//
//  MoradaApp.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import SwiftUI

@main
struct MoradaApp: App {
    @StateObject var sessionManager = UserSession()
    @StateObject var router = CustomRouter()
    @State private var isSplashActive = true
    
    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                SplashScreen()
                    .onAppear {
                        // Simula un tiempo de espera de 2 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isSplashActive = false
                            }
                        }
                    }
            } else {
                NavigationStack(path: $router.navPath){
                    Group{
                        if sessionManager.isLoggedIn {
                            HomeView()
                                
                        } else {
                            ContentView()
                                
                        }
                    }
                    .navigationDestination(for: CustomRouter.Destination.self) { destination in
                        switch destination {
                        case .recoveryPass:
                            PasswordView().navigationBarBackButtonHidden(true)
                        case .login:
                            ContentView().navigationBarBackButtonHidden(true)
                        case .signup:
                            NewUserView().navigationBarBackButtonHidden(true)
                            
                        case .home: HomeView().navigationBarBackButtonHidden(true)
                        }
                    }
                }
                
                .environmentObject(router)
            }
            
            
        }
    }
}
