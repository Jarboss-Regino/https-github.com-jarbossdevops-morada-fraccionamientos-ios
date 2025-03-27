//
//  CheckinView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/09/24.
//

import SwiftUI

struct CheckinView: View {
    
    @ObservedObject var viewModel = CheckinViewModel()
    @State private var isShowingScanner = false
    var body: some View {
        //NavigationStack{
            ScrollView{
                VStack {
                    
                    Text("Registro de entrada").font(.largeTitle)
                    
                    VStack{
                        HStack {
                            Text("¿Código de entrada?")
                            Toggle("", isOn: $viewModel.isOn)
                        }
                        
                        
                    }.padding(.top,40)
                    
                    if viewModel.isOn {
                        
                        Button(action: {
                            
                            Task{
                                viewModel.resetMessageError()
                            }
                            isShowingScanner = true
                            
                        }) {
                            HStack{
                                Image(systemName: "qrcode.viewfinder")
                                    .foregroundColor(.white)
                                Text("Escanear Código")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    
                            }
                            
                        }.frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 5)
                            .padding(.bottom,10)
                    }
                    
                    if viewModel.isOn {
                        VStack {
                            TextField("Nombre y apellido", text: $viewModel.name)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        VStack {
                            TextField("Número", text: $viewModel.number)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        VStack {
                            TextField("Correo", text: $viewModel.email)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        VStack {
                            TextField("Fecha de llegada", text: $viewModel.arrivalDate)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        VStack {
                            TextField("Domicilio", text: $viewModel.address)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        
                        
                    }else{
                        // textfields
                        VStack {
                            TextField("Nombre y apellido", text: $viewModel.name)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        VStack {
                            TextField("Asunto", text: $viewModel.issue)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        HStack() {
                            Text("Visita a:")
                                
                            Spacer()
                            Menu {
                                ForEach(viewModel.names, id: \.id) { option in
                                    Button(action: {
                                        viewModel.selectedName = option
                                        viewModel.address = viewModel.selectedName?.address ?? ""
                                    }) {
                                        Text(option.name)
                                            .padding()
                                            .cornerRadius(8)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedName?.name ?? "Selecciona una opción")
                                       
                                        .overlay(
                                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                                .mask({
                                                    Text(viewModel.selectedName?.name ?? "Selecciona una opción")
                                                        
                                                })
                                        )
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }.padding(.leading,25)
                                .cornerRadius(8)
                            }

                          
                        }.frame(maxHeight: .infinity)
                        
                        
                        
                        
                        
                        
                        VStack {
                            TextField("Domicilio", text: $viewModel.address)
                                .cornerRadius(16)
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        VStack {
                            TextField("Teléfono", text: $viewModel.number)
                                .cornerRadius(16)
                                .keyboardType(.numberPad)
                                .onChange(of: viewModel.number, { oldValue, newValue in
                                    viewModel.number = String(newValue.prefix(10)).filter { $0.isNumber }
                                })
                                
                            LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 2)
                        }.frame(height: 60)
                        
                        
                        HStack {
                            Text("Tipo de visita:")
                            Spacer()
                            
                            Menu {
                                ForEach(viewModel.tiposVisita, id: \.self) { option in
                                    Button(action: {
                                        viewModel.selectedOption = option
                                    }) {
                                        Text(option)
                                            .padding()
                                            .cornerRadius(8)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedOption ?? "Selecciona una opción")
                                       
                                        .overlay(
                                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                                .mask({
                                                    Text( viewModel.selectedOption  ?? "Selecciona una opción")
                                                        
                                                })
                                        )
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }.padding(.leading,10)
                                .cornerRadius(8)
                            }
                            

                          
                        }.frame(maxHeight: .infinity)
                        
                    }
                    
                    
                    //Buttons
                    VStack{
                        Button(action: {
                            
                            print("Botón de inicio de sesión presionado")
                        }) {
                            HStack{
                                Image(systemName: "camera.fill") // Ícono
                                    .foregroundColor(.white)
                                Text("Placa del vehículo")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    
                            }
                            
                        }.frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            
                        Button(action: {
                            
                            print("Botón de inicio de sesión presionado")
                        }) {
                            HStack{
                                Image(systemName: "camera.fill") // Ícono
                                    .foregroundColor(.white)
                                Text("INE / Licencia")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    
                            }
                            
                        }.frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 5)
                        
                        if viewModel.showError {
                            Text("\(viewModel.messageError)")
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                        }
                        if viewModel.showSuccessMsg {
                            Text("\(viewModel.msgSuccess)")
                                .foregroundColor(.green)
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                        }
                        
                        Button(action: {
                            Task{
                                await viewModel.doRegister()
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
                    }.padding(.top, 60)
                    
                    
                }.padding(.horizontal, 16).padding(.horizontal)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $isShowingScanner) {
                QRCodeScannerView{ value in
                    isShowingScanner = false
                    Task{
                        await viewModel.searchVisitData(idValue: value)
                    }
                }
            }
        //}
           
    }
}

#Preview {
    CheckinView()
}
