//
//  AddIncident.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 18/10/24.
//

import SwiftUI

struct AddIncidentView: View {
    @ObservedObject var viewModel: MoreViewModel
    @Binding var showSheet: Bool
    var body: some View {
        VStack{
            
            Text("Registrar Incidente").font(.title).padding(.bottom,20).padding(.top,20)
            HStack {
                Text("Clasificación:")
                Spacer()
                
                Menu {
                    ForEach(viewModel.classificationItems, id: \.id) { option in
                        Button(action: {
                            viewModel.selectedClassication = option
                        }) {
                            Text(option.name)
                                .padding()
                                .cornerRadius(8)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedClassication?.name ?? "Selecciona una opción")
                           
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    .mask({
                                        Text( viewModel.selectedClassication?.name  ?? "Selecciona una opción")
                                            
                                    })
                            )
                        Spacer()
                        Image(systemName: "chevron.down")
                    }.padding(.leading,10)
                    .cornerRadius(8)
                }

            }
            
            VStack {
                TextField("Descripción", text: $viewModel.description)
                    .cornerRadius(16)
                LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
            }.frame(height: 60)
            VStack {
                TextField("Comentarios", text: $viewModel.incidentComment)
                    .cornerRadius(16)
                LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
            }.frame(height: 60)
            // BUTTONS
            VStack{
                                    
                Button(action: {
                    
                    print("Botón de inicio de sesión presionado")
                }) {
                    HStack{
                        Image(systemName: "camera.fill") // Ícono
                            .foregroundColor(.white)
                        Text("Adjuntar fotografía")
                            .padding()
                            .foregroundColor(.white)
                            .font(.headline)
                            
                    }
                    
                }.frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 5)
                
                
                if viewModel.showErrorIncident {
                    Text("\(viewModel.errorMessageIncident)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                if viewModel.showMessageIncident {
                    Text("\(viewModel.successMessageIncident)")
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                
                Button(action: {
                    Task{
                        //viewModel.doRegister()
                        await viewModel.creaNewIncident()
                    }
                    print("Botón de inicio de sesión presionado")
                }) {
                    Text("Registrar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                        )
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                }.padding(.top, 20)
                
                
            }.padding(.top, 40)
            
            Spacer()
        }.padding(.horizontal, 32).frame(maxHeight: .infinity)
        
    }
}

//#Preview {
//    AddIncidentView(viewModel: MoreViewModel())
//}
