//
//  EventsView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 09/10/24.
//

import SwiftUI

struct EventsView: View {
    @ObservedObject var moreViewModel: MoreViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    @State private var isActive = false
    @State private var calendarID = UUID()
    
    var body: some View {
        
            ZStack {
                List(moreViewModel.events, id: \.id) { option in
                    ItemEventView(data: option,viewModel: moreViewModel)
                }.listStyle(.inset).frame(maxWidth: .infinity).padding(.horizontal,32).padding(.top,10).scrollIndicators(.hidden).refreshable {
                    Task{
                        
                        await moreViewModel.getEvents()
                    }
                }
                
            }
            
        
        .frame(maxWidth: .infinity, maxHeight: .infinity).overlay(
            Group {
                if moreViewModel.showPopupEvent, let evento =
                    moreViewModel.selectedEvent {
                    CustomDialogEvent(isActive: $moreViewModel.showPopupEvent, data: evento)
                }
            }
        )
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                CustomToolbar(
                    title: "Eventos",
                    dismissAction: { dismiss() },
                    trailingAction: {
                        isSheetPresented = true
                    }
                ).sheet(isPresented: $isSheetPresented) {
                    AddEventView(isPresented: $isSheetPresented).presentationDetents([.large]).onDisappear{
                        Task{
                            await moreViewModel.getEvents()
                            
                        }

                    }
                    
                }
            }
            
        }).navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline).onAppear{
                Task{
                    await moreViewModel.getEvents()
                    
                }
            }
    
        
    }
}

struct AddEventView: View {
    @ObservedObject var adminViewModel = AdminViewModel()
    @Binding var isPresented: Bool
    @State private var isDatePickerVisible = false
    @State private var isStartTimePickerVisible = false
    @State private var isEndTimePickerVisible = false
    @State private var isActive = false
    var body: some View {
        ScrollView{
            ZStack {
                VStack {
                    
                                  
                    Text("Registrar evento").font(.title).padding(.top,10)
                    
                    VStack {
                        
                        
                        Menu {
                            ForEach(adminViewModel.admins, id: \.uuid) { option in
                                
                                Button(action: {
                                    adminViewModel.selectedAdmin = option
                                }) {
                                    Text(option.name)
                                        .padding()
                                        .cornerRadius(8)
                                }
                                
                            }
                        } label: {
                            HStack {
                                Text(adminViewModel.selectedAdmin?.name ?? "Selecciona un administrador")
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                            .mask({
                                                Text(adminViewModel.selectedAdmin?.name ?? "Selecciona un administrador")
                                                
                                            })
                                    )
                                Spacer()
                                Image(systemName: "chevron.down")
                            }.padding(.leading,10)
                                .cornerRadius(8)
                        }
                        
                        
                    }
                    
                    
                    CustomTextField(placeholder: "Título", text: $adminViewModel.titleEvent)
                    CustomTextField(placeholder: "Descripción", text: $adminViewModel.descriptionEvent)
                    Text("Número de personas").font(.headline).padding(.top,20)
                    VStack {
                        
                        Picker("", selection: $adminViewModel.numPeople) {
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
                        
                    }.padding(.horizontal,16)
                        .frame(width: 90)
                    VStack {
                        Text("Fecha de reservación: ").font(.headline)
                        
                        Text(adminViewModel.date, formatter: dateFormatter)
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
                        
                    }.padding(.top,30)
                    VStack {
                        Text("Hora de entrada:").font(.headline)
                        Text(adminViewModel.startTime, formatter: timeFormatter)
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
                    }.padding(.top,30)
                    
                    VStack {
                        Text("Hora de salida:").font(.headline)
                        Text(adminViewModel.endTime, formatter: timeFormatter)
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
                    }.padding(.top,30)
                    
                    
                    Spacer()
                    if adminViewModel.isLoading {
                        ProgressView("Cargando...")  // Indicador de carga
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                    if adminViewModel.showMessage {
                        Text("\(adminViewModel.successMessage)")
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                    }
                    
                    if adminViewModel.showError {
                        Text("\(adminViewModel.errorMessage)")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                    }
                    
                    
                    Spacer()
                    Button(action: {
                        Task{
                            await adminViewModel.creaeNewEvent()
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
                        .disabled(adminViewModel.disableButton)
                        .opacity(adminViewModel.disableButton ? 0.5 : 1.0)
                }
                
                // DatePicker como popup
                if isDatePickerVisible {
                    VStack {
                        DatePicker("Selecciona una fecha", selection: $adminViewModel.date, displayedComponents: .date)
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
                
                if isStartTimePickerVisible {
                    
                    PopupDatePicker(selection: $adminViewModel.startTime, title: "Selecciona una hora", displayedComponents: .hourAndMinute) {
                        isStartTimePickerVisible = false
                    }
                    
                    
                }
                
                // DatePicker para la hora de salida
                if isEndTimePickerVisible {
                    PopupDatePicker(selection: $adminViewModel.endTime, title: "Selecciona una hora", displayedComponents: .hourAndMinute) {
                        isEndTimePickerVisible = false
                    }
                }
            }.padding(.horizontal,16).ignoresSafeArea(.keyboard, edges: .bottom)
            
            
            
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

