//
//  MoreView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/09/24.
//

import SwiftUI

struct MoreView: View {
    
    @ObservedObject var viewModel = MoreViewModel()
    let click: () -> Void
    @State var path = NavigationPath()
    var body: some View {
        
        //NavigationStack{
            if let tipo = viewModel.tipoUsuario {
                //NavigationStack{
                VStack{
                    if tipo == "residente" {
                        
//                        NavigationLink(destination: Events().navigationBarBackButtonHidden(true)) {
//                            defaultButton(icon: "camera.fill", title: "Eventos")
//                        }
                        NavigationLink(destination: IncidentsView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Incidencias")
                        }
                        

                    }
                    else if tipo == "administrativo"{
                        NavigationLink(destination: EventsView(moreViewModel: viewModel).navigationBarBackButtonHidden(true)) {
                            defaultButton(icon: "camera.fill", title: "Eventos")
                        }
                        NavigationLink(destination: IncidentsView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Incidencias")
                        }
                        
                        NavigationLink(destination: ReservationsView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Reservaciones")
                        }
                        NavigationLink(destination: AvisosView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Avisos")
                        }
                        
                        
                        
                    }else if tipo == "operativo"{
                        
                        NavigationLink(destination: EventsView(moreViewModel: viewModel).navigationBarBackButtonHidden(true)) {
                            defaultButton(icon: "camera.fill", title: "Eventos")
                        }
                        NavigationLink(destination: IncidentsView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Incidencias")
                        }
                        
                        NavigationLink(destination: ReservationsView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Reservaciones")
                        }
                        NavigationLink(destination: AvisosView(viewModel: viewModel).navigationBarBackButtonHidden(true)){
                            defaultButton(icon: "camera.fill", title: "Avisos")
                        }
                        
                        
                        
                    }

                        buttonView(icon: "camera.fill", title: "Cerrar sesión", action: {
                            
                            viewModel.logout()
                            click()
                          
                        })

                    
                   

                    
                    Spacer()
                }.frame(maxWidth: .infinity,maxHeight: .infinity)

                //}
                
            }else {
                // Si `tipo` no está disponible aún, mostrar un cargando
                ProgressView("Cargando...")
            }
        //}
    }
}

struct defaultButton: View {
    let icon: String
    let title: String
    
    var body: some View{
        HStack {
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .padding(.leading, 10)
            
            Text(title)
                .padding()
                .foregroundColor(.black)
                .font(.headline)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.top, 30)
        .padding(.horizontal, 32)
        .shadow(radius: 5)
            
    }
}


struct buttonView: View{
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            
                action()
            
            
           
        }) {
            HStack{
                ZStack {
                    
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }.padding(.leading, 10)
                    
                    
                Text(title)
                    .padding()
                    .foregroundColor(.black)
                    .font(.headline)
                
                Spacer()
                    
            }
            
        }.frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 30)
            .padding(.horizontal,32)
            .shadow(radius: 5)
    }
}

//#Preview {
//    MoreView(onLogout: {})
//}
