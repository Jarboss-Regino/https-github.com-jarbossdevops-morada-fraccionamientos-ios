//
//  HomeView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 24/09/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()   
    @ObservedObject var reViewModel = ResidentViewModel()
    @EnvironmentObject var router: CustomRouter
    @Environment(\.dismiss) var dismiss  // Para navegar de vuelta
    @State private var selectedTab = 0
    var body: some View {
        //NavigationStack{
            if let tipo = viewModel.tipoUsuario {
                TabView(selection: $selectedTab) {
                    // Definimos las opciones para el tipo 1
                    if tipo == "residente" {
                        
                        Avisos(viewModel: reViewModel)
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 0 ? "comu_pres" : "comu_nor")
                                    Text("Avisos")
                                        .foregroundColor(selectedTab == 0 ? .pink : .gray)
                                }
                            }.tag(0)
                        
                        AccessView()
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 1 ? "Hulla_pres" : "Hulla_nor")
                                    Text("Entradas")
                                        .foregroundColor(selectedTab == 1 ? .pink : .gray)
                                }
                                
                                
                            }.tag(1)
                        
                        Reservation(viewModel: reViewModel)
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 2 ? "rese_pres" : "rese_nor")
                                    Text("Reservaciones")
                                        .foregroundColor(selectedTab == 2 ? .pink : .gray)
                                }
                            }.tag(2)
                        MoreView(){
                            router.navigateToRoot()
                        }.tabItem {
                            VStack {
                                Image(selectedTab == 3 ? "menu_pres" : "menu_nor")
                                Text("Más")
                                    .foregroundColor(selectedTab == 3 ? .pink : .gray)
                            }
                            
                        }.tag(3)
                    }
                    
                    // Definimos las opciones para el tipo 2
                    else if tipo == "administrativo" {
                        CheckinView()
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 0 ? "entrada_pres" : "entrada_nor")
                                    Text("Entradas")
                                        .foregroundColor(selectedTab == 0 ? .pink : .gray)
                                }
                            }.tag(0)
                        
                        CheckOutView()
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 1 ? "salida_pres" : "salida_nor")
                                    Text("Salidas")
                                        .foregroundColor(selectedTab == 1 ? .pink : .gray)
                                }
                            }.tag(1)
                        
                        MoreView(){
                    
                            router.navigateToRoot()
                        }.tabItem {
                            VStack {
                                Image(selectedTab == 2 ? "menu_pres" : "menu_nor")
                                Text("Más")
                                    .foregroundColor(selectedTab == 2 ? .pink : .gray)
                            }
                        }.tag(2)
                    }
                    
                    // Definimos opciones genéricas para otros tipos o por defecto
                    else if tipo == "operativo"{
                        
                        CheckinView()
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 0 ? "entrada_pres" : "entrada_nor")
                                    Text("Entradas")
                                        .foregroundColor(selectedTab == 0 ? .pink : .gray)
                                }
                            }.tag(0)
                        
                        CheckOutView()
                            .tabItem {
                                VStack {
                                    Image(selectedTab == 1 ? "salida_pres" : "salida_nor")
                                    Text("Salidas")
                                        .foregroundColor(selectedTab == 1 ? .pink : .gray)
                                }
                            }.tag(1)
                        
                        MoreView(){
                            
                            router.navigateToRoot()
                        }.tabItem {
                            VStack {
                                Image(selectedTab == 2 ? "menu_pres" : "menu_nor")
                                Text("Más")
                                    .foregroundColor(selectedTab == 2 ? .pink : .gray)
                            }
                        }.tag(2)
                        
                        
                    }
                }
            } else {
                // Si tipo no está disponible aún, mostrar un cargando
                ProgressView("Cargando...")
            }
        //}
       }
   }

//#Preview {
//    HomeView()
//}
