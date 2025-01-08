//
//  NewUserView.swift
//  Morada
//
//  Created by MacBook Air on 20/09/24.
//

import SwiftUI

struct NewUserView: View {
    
    @ObservedObject var viewModel = NewUserViewModel()
    @EnvironmentObject var router: CustomRouter
    //@Binding var path: [Routes]

    @State var isSecure = true
    @FocusState private var isFocused: Bool
    
    var body: some View {
        //NavigationView {
            VStack{
                Text("").font(.largeTitle).padding(.top, 120)
     
                
                VStack {
                    TextField("Escribre tu nombre", text: $viewModel.name)
                        .cornerRadius(16)
                    LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(height: 2)
                }.padding(.horizontal, 16)
                    .frame(height: 60)
                
                ZStack {
                    VStack {
                        TextField("Escribre tu correo", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .cornerRadius(16)
                        LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(height: 2)
                    }.padding(.horizontal, 16)
                        .frame(height: 60)
                    
                    if viewModel.isLoading {
                        ProgressView("Cargando...")  // Indicador de carga
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
                
                
                // passs
                VStack {
                    
                    ZStack(alignment: .trailing){
                        if isSecure {
                            SecureField("Escribe tu contraseña", text: $viewModel.password)
                            .cornerRadius(16)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        }else {
                            TextField("Escribe tu contraseña", text: $viewModel.password)
                            .cornerRadius(16)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        }
                        Button(action: {
                            isSecure = !isSecure
                            isFocused = true
                        }, label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(
                                        Image(systemName: isSecure ? "eye.slash" : "eye")
                                            
                                    )
                                )
                        })
                        
                    }.padding(.bottom,0.5)
                    LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(height: 2)
                    
                }.padding(.horizontal, 16).frame(height: 60)
                
                VStack {
                    TextField("Confirmar contraseña", text: $viewModel.confirmPass)
                        .cornerRadius(16)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(height: 2)
                }.padding(.horizontal, 16)
                    .frame(height: 60)
                
                Button(action: {
                    // Acción del botón de inicio de sesión
                    Task{
                        await viewModel.createNewAccount()
                    }
                    
                    print("Botón crear cuenta presionado")
                }) {
                    Text("Crear cuenta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                        )
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        .padding(.top,10)
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).padding(.horizontal,16).disabled(viewModel.isLoading).padding(.horizontal)
                
                if viewModel.showMessageSuccess {
                    Text("\(viewModel.messageSuccess)")
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                
                if viewModel.showError {
                    Text("\(viewModel.errorMessage)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                if viewModel.showErrorEmail {
                    Text("\(viewModel.errorMessageEmail)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                if viewModel.showErrorpass {
                    Text("\(viewModel.errorPassword)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                
                
                Spacer()
                
            }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).onAppear{
                Task{
                    viewModel.showMessageSuccess = false
                    viewModel.showError = false
                    viewModel.showErrorpass = false
                    viewModel.showErrorEmail = false
                    
                    
                    
                }
        }.toolbar(content: {
            ToolbarItem(placement: .principal) {
                ToolBarBack(title: "Crear cuenta", dismissAction: {router.navigateBack()})
            }
        }).navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        ///}
    }
}

//#Preview {
//    NewUserView()
//}
