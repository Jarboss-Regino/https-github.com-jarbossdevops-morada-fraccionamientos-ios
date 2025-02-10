//
//  RegisterVisit.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 06/11/24.
//

import SwiftUI

struct RegisterVisitView: View {
    @ObservedObject var viewModel = AccessViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            
                
            ZStack{
                
                bodyView(viewModel: viewModel).padding(.top,30)
                
            }
            .frame(maxWidth: .infinity).padding(.horizontal, 32)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    ToolBarBack(title: "Registro de visitante", dismissAction: {dismiss()})
                }
            }).navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    viewModel.disableButton = false
                    viewModel.resetFields()
                }
                
            
        }
    }
}

struct bodyView: View {
    @ObservedObject var viewModel: AccessViewModel
    @State var isDatePickerVisible = false
    @State var startEventPickerVisible = false
    @State var isStartTimePickerVisible = false
    @State var isEndTimePickerVisible = false
    var body: some View {
        VStack{
            
            
            
            
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
                TextField("Teléfono", text: $viewModel.phone)
                    .cornerRadius(16)
                    .onChange(of: viewModel.phone) { oldValue, newValue in
                        viewModel.phone = String(newValue.prefix(10).filter { $0.isNumber })

                    }
                LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
            }.frame(height: 60)
            
            VStack {
                TextField("Tipo de visita", text: $viewModel.typeVisit)
                    .cornerRadius(16)
                LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
            }.frame(height: 60)
            
            HStack {
                Text("Fecha de llegada: ").font(.headline)
                Spacer()
                Text(viewModel.date, formatter: dateFormatter)
                    .onTapGesture {
                        withAnimation {
                            isDatePickerVisible.toggle()
                        }
                    }.padding(8).background(
                        RoundedRectangle(cornerRadius: 10) // Fondo redondeado
                            .fill(Color.purple.opacity(0.1)) // Color de fondo con opacidad
                    ).overlay( // Borde con color púrpura y opacidad
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple.opacity(0.6), lineWidth: 2)
                    )
                    
            }.padding(.top,10)
            
            HStack {
                Text("Hora de evento:").font(.headline)
                Spacer()
                Text(viewModel.eventTime, formatter: timeFormatter)
                    .onTapGesture {
                        withAnimation {
                            startEventPickerVisible.toggle()
                        }
                    }.padding(8).background(
                        RoundedRectangle(cornerRadius: 10) // Fondo redondeado
                            .fill(Color.purple.opacity(0.1)) // Color de fondo con opacidad
                    ).overlay( // Borde con color púrpura y opacidad
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple.opacity(0.6), lineWidth: 2)
                    )
            }.padding(.top,10)
            
            HStack {
                Text("Visita a:").font(.headline)
                Spacer()
                
                Menu {
                    ForEach(viewModel.residentsList, id: \.id) { option in
                        Button(action: {
                            //viewModel.resetFields()
                            viewModel.selectedResident = option
                        }) {
                            Text(option.name)
                                .padding()
                                .cornerRadius(8)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedResident?.name ?? "Selecciona una opción")
                           
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    .mask({
                                        Text( viewModel.selectedResident?.name  ?? "Selecciona una opción")
                                            
                                    })
                            )
                        Spacer()
                        Image(systemName: "chevron.down")
                    }.padding(.leading,10)
                    .cornerRadius(8)
                }
                

              
            }.padding(.top, 10)
            
           
            
            // ERRORS MESSAGE AND BUTTON
            Spacer()
            if viewModel.isLoading {
                ProgressView("Cargando...")  // Indicador de carga
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
            if viewModel.showMessage {
                Text("\(viewModel.successMessage)")
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
            
            
            
            Button(action: {
                Task{
                    await viewModel.creaeNewEvent()
                }
                print("Botón de registar presionado")
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
            }.padding(.horizontal,16)
                .disabled(viewModel.disableButton)
                .opacity(viewModel.disableButton ? 0.5 : 1.0)
        }
        
        // DatePicker como popup
        if isDatePickerVisible {
            VStack {
                DatePicker("Selecciona una fecha", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .accentColor(.purple)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                
                Button("Aceptar") {
                    withAnimation {
                        isDatePickerVisible = false  // Cierra el DatePicker
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        
        if startEventPickerVisible {
            
            PopupDatePicker(selection: $viewModel.eventTime, title: "Hora de evento", displayedComponents: .hourAndMinute) {
                startEventPickerVisible = false
            }
            
            
        }
        if isStartTimePickerVisible {
            VStack {
                DatePicker("Fecha inicio", selection: $viewModel.startTime, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .accentColor(.purple)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                
                Button("Aceptar") {
                    withAnimation {
                        isStartTimePickerVisible = false  // Cierra el DatePicker
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        if isEndTimePickerVisible {
            VStack {
                DatePicker("Fecha inicio", selection: $viewModel.endTime, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .accentColor(.purple)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                
                Button("Aceptar") {
                    withAnimation {
                        isEndTimePickerVisible = false  // Cierra el DatePicker
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

#Preview {
    RegisterVisitView()
}
