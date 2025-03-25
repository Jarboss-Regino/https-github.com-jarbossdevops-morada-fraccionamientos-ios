//
//  AddAvisoView.swift
//  Morada
//
//  Created by MacBook Air on 29/01/25.
//

import SwiftUI

struct AddAvisoView: View {
    @ObservedObject var viewModel: MoreViewModel
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    
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
               showCamera = true
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
                .sheet(isPresented: $showCamera) {
                    CameraPicker(isPresented: $showCamera, image: $selectedImage)
                }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
            
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
                if let image = selectedImage {
                    viewModel.convertToBase64(image: image)
                    if let base64String = viewModel.base64Image {
                        Task{
                            await viewModel.createAviso(image: base64String)
                        }
                    }
                }
                
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
            }.padding(.top, 20).disabled(selectedImage == nil)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.horizontal,16).ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


