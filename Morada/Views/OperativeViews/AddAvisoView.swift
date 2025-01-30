//
//  AddAvisoView.swift
//  Morada
//
//  Created by MacBook Air on 29/01/25.
//

import SwiftUI

struct AddAvisoView: View {
    @ObservedObject var viewModel: MoreViewModel
    var body: some View {
        VStack{
            Text("Crear Aviso")
                .font(.largeTitle).padding(.top,20)
            CustomTextField(placeholder: "Lugar", text: $viewModel.placeAviso)
            CustomTextField(placeholder: "Descripción", text: $viewModel.descriptionAviso)
            
//            if viewModel.isLoadingReservations {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .padding()
//                
//            }
            
            Button(action: {
               
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
            
            Spacer()
            if viewModel.showErrorAviso {
                Text("\(viewModel.errorMsgAviso)")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal, 16)
            }
            if viewModel.showSuccessAviso {
                Text("\(viewModel.successMsgAviso)")
                    .foregroundColor(.green)
                    .font(.subheadline)
                    .padding(.horizontal, 16)
            }
            
            Button(action: {
                
                Task{
                    await viewModel.createAviso()
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
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.horizontal,16).ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


