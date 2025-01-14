//
//  IncidentsView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 16/10/24.
//

import SwiftUI

struct IncidentsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDatePickerVisible = false
    @State private var showPopup = false
    @State private var isSheetPresented = false
    @ObservedObject var viewModel: MoreViewModel
    
    var body: some View {
        //NavigationStack {
            ZStack {
                VStack{
                    VStack {
                        HStack {
                            Text("Buscar por fecha: ")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text(viewModel.fetchDate, formatter: viewModel.getDateFormatter())
                                .onTapGesture {
                                    withAnimation {
                                        isDatePickerVisible.toggle()
                                    }
                            }.padding(8).background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.purple.opacity(0.1))
                            ).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple.opacity(0.6), lineWidth: 2)
                            )
                            Spacer()
                        }
                        
                    }.padding(.horizontal, 32).padding(.top,30)
                    
                    
                    if viewModel.isLoadingIncidents {
                        ProgressView() // Circular progress mientras se realiza la búsqueda
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Spacer()
                    } else {
                        List(viewModel.incidents, id: \.id) { option in
                            itemIncident(data: option, mviewModel: viewModel)
                        }.listStyle(.inset).frame(maxWidth: .infinity).padding(.horizontal,32).padding(.top,10).scrollIndicators(.hidden).refreshable {
                            Task{
                                viewModel.fetchDate = Date()
                                await viewModel.getIncidents()
                            }
                        }
                    }
                    
                    
                }
                .onAppear{
                    Task{
                        await viewModel.getIncidents()
                    }
                }
                
                if isDatePickerVisible {
                    VStack {
                        
                        DatePicker("Selecciona una fecha", selection: $viewModel.fetchDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .accentColor(.purple)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                        
                        HStack {
                                                        
                            Button("Cancelar") {
                                withAnimation {
                                    isDatePickerVisible = false
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Buscar") {
                                Task{
                                    await viewModel.fetchIncidentsByDate()
                                    
                                }
                                withAnimation {
                                    isDatePickerVisible = false
                                    
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
            }
            .overlay(
                Group{
                    if viewModel.showPopupIncident, let incident =
                        viewModel.selectedIncident {
                        CustomDialogIncident(isActive: $viewModel.showPopupIncident, data: incident)
                    }
                }
            ).toolbar(content: {
                ToolbarItem(placement: .principal) {
                        CustomToolbar(
                            title: "Incidencias",
                            dismissAction: { dismiss() },
                            trailingAction: {
                                // Acción del botón "+" aquí
                                isSheetPresented = true
                            }
                        )
                        .sheet(isPresented: $isSheetPresented, content: {
                            AddIncidentView(viewModel: viewModel, showSheet: $isSheetPresented)
                        })
                    }
                })
                .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
            
            
        //}
}

struct itemIncident: View{
    var data: IncidentsResponse
    @ObservedObject var mviewModel: MoreViewModel
    
    private var circleColor: Color {
        switch data.status {
            case "0":
                return .red
            case "2":
                return .yellow
            default:
                return .green
            }
        }
    
        
    var body: some View{
        HStack {
            Circle()
                .fill(circleColor)
                .frame(width: 30, height: 30).padding(.leading,15)
            
            
            VStack(alignment: .leading, spacing: 5.0, content: {
                Text("\(data.classification)")
                    .font(.body).fontWeight(.semibold)
                .foregroundColor(.primary)
                Text("\(data.description)")
                    .font(.body)
                .foregroundColor(.secondary)
            }).padding(.leading,20).padding(.vertical,10)
            Spacer()
        }
        
        .listRowBackground(Color.white)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        )
        .listRowInsets(EdgeInsets())
        .padding(.vertical,5)
        .onTapGesture {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                mviewModel.selectedIncident = data
                mviewModel.showPopupIncident = true
            }
        }
        
        
        
        
    }
}


