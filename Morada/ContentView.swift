//
//  ContentView.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import SwiftUI

struct ContentView: View {
        
    @ObservedObject var viewModel = LoginViewModel()
    @State var isSecure = true
    @FocusState private var isFocused: Bool
    @EnvironmentObject var router: CustomRouter
    
    var body: some View {
        //NavigationStack(path:$path){
            VStack {
                Image("logo")
                    .resizable()
                    .imageScale(.medium)
                    .frame(width: 100, height: 100)
                    .padding(.top, 40)
                Text("Morada")
                    .font(.largeTitle)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            .mask({
                                Text("Morada")
                                    .font(.largeTitle)
                            })
                    )
                
            }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
            
                
            
            
            
        VStack {
            VStack {
                TextField("Escribre tu correo", text: $viewModel.username)
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
                
            }.padding(.horizontal, 16)
            
            Spacer().frame(height: 50)
            if viewModel.showError {
                Text("\(viewModel.errorMessage)")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal, 16)
            }
            
            Button(action: {
                // Acción del botón de inicio de sesión
                Task{
                   await viewModel.doLogin()
                    if viewModel.loginSuccess {
                        router.navigate(to: .home) // Navegar a la pantalla de inicio si el login es exitoso
                   }
                }
                
                
                
                print("Botón de inicio de sesión presionado")
            }) {
                Text("Iniciar Sesión")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                    )
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }.disabled(viewModel.isLoading)
            
            
            
        }.frame(maxHeight: .infinity).padding(.horizontal,16)
        
        if viewModel.isLoading {
            ProgressView("Cargando...")  // Indicador de carga
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
        }
            
        VStack {
//            NavigationLink(destination: {PasswordView(viewModel: viewModel).navigationBarBackButtonHidden(true)}, label: {
//
//            })
            Button(action: {
                router.navigate(to: .recoveryPass)
            }) {
                Text("¿Olvidaste tu contraseña?")
                    .foregroundColor(.purple)
                    .padding(.bottom, 5)
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask {
                            Text("¿Olvidaste tu contraseña?")
                                .padding(.bottom, 5)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            HStack {
                Text("¿No tienes una cuenta?")
                Button(action: {
                    router.navigate(to: .signup)
                }) {
                    Text("Regístrate")
                        .foregroundColor(.purple)
                        .padding(.bottom, 5)
                        .overlay {
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask {
                                Text("Regístrate")
                                    .padding(.bottom, 5)
                            }
                        }
                }
                .buttonStyle(PlainButtonStyle())
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom) // Alinear abajo
        .padding(.bottom, 40)
   

    }
}

//#Preview {
//    ContentView()
//}
