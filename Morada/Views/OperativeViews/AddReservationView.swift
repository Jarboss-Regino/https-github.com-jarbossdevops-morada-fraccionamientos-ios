//
//  AddReservationView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 22/10/24.
//

import SwiftUI

struct AddReservationView: View {
    @ObservedObject var viewModel: MoreViewModel
    @Binding var showSheet: Bool
    @State private var isDatePickerVisible = false
    @State private var isStartTimePickerVisible = false
    @State private var isEndTimePickerVisible = false
    var body: some View {
        ScrollView{
            ZStack {
                VStack{
                    HStack {
                        Spacer()
                        Button {
                            //Task{
                            //isPresented = false
                            showSheet = false
                            //await viewModel.getEvents()
                            //viewModel.resetFields()
                            //}
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.black)
                        .padding(.vertical)
                        
                    }
                    Text("Reservar").font(.title).padding(.bottom,15)
                    
                    
                    VStack {
                        TextField("Lugar que  se reserva", text: $viewModel.placeReservation)
                            .cornerRadius(16)
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
                    }.frame(height: 60)
                    
                    VStack {
                        TextField("Cometarios", text: $viewModel.comments)
                            .cornerRadius(16)
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 2)
                    }.frame(height: 60)
                    
                    
                    
                    VStack() {
                        Text("Persona que reserva:").font(.headline)
                            
                        Menu {
                            ForEach(viewModel.residentsList, id: \.id) { option in
                                Button(action: {
                                    viewModel.selectedResident = option
                                }) {
                                    Text(option.nombre)
                                        .padding()
                                        .cornerRadius(8)
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.selectedResident?.nombre ?? "Selecciona una opción")
                                   
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                            .mask({
                                                Text(viewModel.selectedResident?.nombre ?? "Selecciona una opción")
                                                    
                                            })
                                    )
                                
                                Image(systemName: "chevron.down")
                            }.padding(.leading,25)
                            .cornerRadius(8)
                        }

                      
                    }
                    
                    
                    VStack {
                        Text("Número de personas").font(.headline)
                        Picker("", selection: $viewModel.totalPeople) {
                            ForEach(1..<101) { number in
                                Text("\(number)").tag(number)
                            }
                        }.accentColor(.black).background(
                                RoundedRectangle(cornerRadius: 10) // Fondo redondeado
                                    .fill(Color.purple.opacity(0.1)) // Color de fondo con opacidad
                            ).overlay( // Borde con color púrpura y opacidad
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple.opacity(0.6), lineWidth: 2)
                            )
                        
                    }.padding(.top,10)
                    
                    
                    
                    
                    VStack {
                        Text("Fecha de reservación: ").font(.headline)
                        
                        Text(viewModel.dateReservation, formatter: dateFormatter)
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
                    VStack {
                        Text("Hora de entrada:").font(.headline)
                        Text(viewModel.startTimeReservation, formatter: timeFormatter)
                            .onTapGesture {
                                withAnimation {
                                    isStartTimePickerVisible.toggle()
                                }
                            }.padding(8).background(
                                RoundedRectangle(cornerRadius: 10) // Fondo redondeado
                                    .fill(Color.purple.opacity(0.1)) // Color de fondo con opacidad
                            ).overlay( // Borde con color púrpura y opacidad
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple.opacity(0.6), lineWidth: 2)
                            )
                    }.padding(.top,10)
                    
                    VStack {
                        Text("Hora de salida:").font(.headline)
                        Text(viewModel.endTimeReservation, formatter: timeFormatter)
                            .onTapGesture {
                                withAnimation {
                                    isEndTimePickerVisible.toggle()
                                }
                            }.padding(8).background(
                                RoundedRectangle(cornerRadius: 10) // Fondo redondeado
                                    .fill(Color.purple.opacity(0.1)) // Color de fondo con opacidad
                            ).overlay( // Borde con color púrpura y opacidad
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple.opacity(0.6), lineWidth: 2)
                            )
                    }.padding(.top,10)
                    
                    
                    
                    
                    
                    
                    
                    // BUTTONS
                    
                    if viewModel.isLoadingReservations {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Spacer()
                    }
                    if viewModel.showErrorReservation {
                        Text("\(viewModel.errorMessageReservation)")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                    }
                    if viewModel.showMessageReservaton {
                        Text("\(viewModel.successMessageReservation)")
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                    }
                    
                    Button(action: {
                        Task{
                            await viewModel.createReservation()
                        }
                        
                    }) {
                        Text("Reservar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            )
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }.padding(.top, 25).disabled(viewModel.disableButtonReservation)
                        .opacity(viewModel.disableButton ? 0.5 : 1.0)
                    
                    
                }
                
                // DatePicker como popup
                if isDatePickerVisible {
                    VStack {
                        DatePicker("Selecciona una fecha", selection: $viewModel.dateReservation, displayedComponents: .date)
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
                
                //aqui
                if isStartTimePickerVisible {
                    
                    PopupDatePicker(selection: $viewModel.startTimeReservation, title: "Selecciona una hora", displayedComponents: .hourAndMinute) {
                        isStartTimePickerVisible = false
                    }
                    
                }
                
                // DatePicker para la hora de salida
                if isEndTimePickerVisible {
                    PopupDatePicker(selection: $viewModel.endTimeReservation, title: "Selecciona una hora", displayedComponents: .hourAndMinute) {
                        isEndTimePickerVisible = false
                    }
                }
            }
            .padding(.horizontal, 32).onAppear{
                Task{
                    await viewModel.getResidents()
                    viewModel.resetFieldsReseravation()
                }
            }
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

//#Preview {
//    AddReservationView(viewModel: MoreViewModel(), showSheet: true)
//}
