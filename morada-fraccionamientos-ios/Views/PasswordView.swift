//
//  PasswordView.swift
//  Morada
//
//  Created by MacBook Air on 20/09/24.
//

import SwiftUI

struct PasswordView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        
        VStack{
            VStack {
                Text("¿Olvido su contraseña?").font(.title).padding(.bottom,10)
                Text("Enviaremos instrucciones sobre cobre cómo restablecer su contraseña a la dirección de correo electrónico que se registro con nosotros")
                    .padding(.bottom,10)
                    .multilineTextAlignment(.center)
            }.padding(.horizontal, 16)
            
            
            
            
            VStack {
                TextField("Escribre tu correo", text: $viewModel.recoverEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .cornerRadius(16)
                LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
                
                Button(action: {
                    // Acción del botón de inicio de sesión
                    Task{ 
                        await viewModel.sendEmail()
                    }
                    
                    print("Botón enviar email presionado")
                }) {
                    Text("Enviar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                        )
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        .padding(.top,10)
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                if viewModel.showMessage {
                    Text("\(viewModel.succesMessage)")
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
                if viewModel.showEmailError {
                    Text("\(viewModel.errorEmailMessage)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                }
            }.padding(.horizontal, 16).padding(.top,20)
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            
           
            
        
    }
}


struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        // Crea una instancia de ejemplo de tu ViewModel para la vista previa
        PasswordView(viewModel: LoginViewModel())
    }
}

