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
        //NavigationView {
                    ZStack {
                        CalendarView(selectedDate: $moreViewModel.selectedDate, events: $moreViewModel.events)
                            .id(calendarID)
                            .onChange(of: moreViewModel.refreshTrigger,{
                                calendarID = UUID()
                            })
                            .onChange(of: moreViewModel.selectedDate, {
                                moreViewModel.filterEvents()
                                print("onChance")
                            }).onAppear{
                                Task{
                                    moreViewModel.filteredEvents = []
                                    await moreViewModel.getEvents()
                                    print("onAppear")
                                }
                            }
                        if !moreViewModel.filteredEvents.isEmpty {
                               VStack {
                                   HStack {
                                       Spacer()
                                       Button {
                                           moreViewModel.filteredEvents = []
                                       } label: {
                                           Image(systemName: "xmark")
                                               .font(.title2)
                                               .fontWeight(.medium)
                                       }
                                       .tint(.black)
                                       .padding()
                                       
                                   }
                                   Text("Detalles del Aviso")
                                       .font(.title)
                                   
                                   ForEach(moreViewModel.filteredEvents, id: \.id) { event in
                                       VStack(alignment: .leading) {
                                           Text("Usuario: \(event.idUsuario ?? "N/A")")
                                           Text("Fecha: \(event.fechaEvento)")
                                           Text("Hora de Inicio: \(event.horaInicio)")
                                           Text("Hora de Fin: \(event.horaFin)")
                                       }
                                       
                                   }
                                   
                                  
                                   Button(action: {
                                       isActive = true
                                   }, label: {
                                       Text("Eliminar")
                                           .font(.system(size: 16, weight: .bold))
                                           .foregroundColor(.black)
                                           .frame(height: 40)
                                           .padding()
                                   }).disabled(moreViewModel.isVisibleButtonDelEvent)
                                   
                               }
                               .frame(width: 300)
                               .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                               .shadow(radius: 5)
                           }
                        
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).overlay(
                        Group {
                            if isActive {
                                QuestionDialog(isActive: $isActive, title: "¿Está seguro de eliminar este evento?", buttonTitle: "Si", action: {
                                    Task{
                                        await moreViewModel.deleteEvent()
                                        moreViewModel.filteredEvents = []
                                        await moreViewModel.getEvents()
                                        print("Evento eliminado")
                                        
                                    }
                                    
                                })
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
                                AddEventView(viewModel: moreViewModel,isPresented: $isSheetPresented).presentationDetents([.fraction(0.9)]).onDisappear{
                                    Task{
                                        await moreViewModel.getEvents()
                                        
                                    }
                                }
                                
                                
                            }
                        }
                       
                }).navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
        //}
    }
}

struct AddEventView: View {
    @ObservedObject var viewModel: MoreViewModel
    @Binding var isPresented: Bool
    @State private var isDatePickerVisible = false
    @State private var isStartTimePickerVisible = false
    @State private var isEndTimePickerVisible = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        Task{
                            isPresented = false
                            //await viewModel.getEvents()
                            viewModel.resetFields()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .tint(.black)
                    .padding()
                    
                }
                Text("Registrar evento").font(.title).padding(.top,30)
                Text("Número de personas").font(.headline).padding(.top,30)
                VStack {
                    
                    Picker("", selection: $viewModel.numPeople) {
                        ForEach(1..<101) { number in
                            Text("\(number)").tag(number)
                        }
                    }.accentColor(.purple)
                    
                }.padding(.horizontal,16)
                    .frame(width: 90)
                VStack {
                    Text("Fecha de reservación: ").font(.headline)
                    
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
                        
                }.padding(.top,30)
                VStack {
                    Text("Hora de entrada:").font(.headline)
                    Text(viewModel.startTime, formatter: timeFormatter)
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
                    Text(viewModel.endTime, formatter: timeFormatter)
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
            
            if isStartTimePickerVisible {
                
                PopupDatePicker(selection: $viewModel.startTime, title: "Selecciona una hora", displayedComponents: .hourAndMinute) {
                    isStartTimePickerVisible = false
                }
                
                
            }
            
            // DatePicker para la hora de salida
            if isEndTimePickerVisible {
                PopupDatePicker(selection: $viewModel.endTime, title: "Selecciona una hora", displayedComponents: .hourAndMinute) {
                    isEndTimePickerVisible = false
                }
            }
        }.padding(.horizontal,16)
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

