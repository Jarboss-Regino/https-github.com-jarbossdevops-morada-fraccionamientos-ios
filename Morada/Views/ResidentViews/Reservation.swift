//
//  Reservation.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 04/11/24.
//

import SwiftUI

struct Reservation: View {
    @ObservedObject var viewModel = ResidentViewModel()
    @State private var isSheetPresented = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Button(action: {
                        
                        Task{
                            viewModel.changeTitle(title:"Todos")
                            viewModel.changeColor(active: 1)
                            await viewModel.getReservations()
                        }
                        
                        
                        
                    }) {
                        Text("Todos")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                
                                
                                viewModel.selectedButton == 1 ?
                                    AnyView(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    )
                                :
                                    AnyView(
                                        Color.clear
                                    )
                                
                                
                                
                            )
                            .foregroundColor(viewModel.selectedButton == 1 ? .white : .black)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    
                    
                    Button(action: {
                        
                        Task{
                            viewModel.changeTitle(title:"Mis reservaciones")
                            viewModel.changeColor(active: 2)
                            await viewModel.getReservations()
                        }
                        print("Botón de inicio de sesión presionado")
                    }) {
                        Text("Mis reservaciones")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(
                                viewModel.selectedButton == 2 ?
                                    AnyView(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    )
                                :
                                    AnyView(
                                        Color.clear
                                    )
                            )
                            .foregroundColor(viewModel.selectedButton == 2 ? .white : .black)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                }.padding(.top, 20)
                Text(viewModel.titleList).font(.subheadline).padding(.top,10)
                
                // list items
                if viewModel.isLoadingReservations {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                } else {
                    List(viewModel.reservationsItems, id: \.id) { option in
                        itemReservations(data: option, mviewModel: viewModel)
                    }.listStyle(.inset).frame(maxWidth: .infinity).padding(.top,10).scrollIndicators(.hidden).refreshable {
                        Task{
                            await viewModel.getReservations()
                        }
                    }
                }
                
                
                
            }
            .padding(.horizontal,32)
                .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                Group{
                    if viewModel.showPopupReservation, let reservation =
                        viewModel.selectedReservation {
                        CustomDialogReservation(isActive: $viewModel.showPopupReservation, data: reservation)
                    }
                }
            )
            .onAppear{
                Task{
                    await viewModel.getReservations()
                }
            }.toolbar(content: {
                ToolbarItem(placement: .principal) {
                    ToolBar(
                        title: "Reservaciones",
                        trailingAction: {
                            isSheetPresented = true
                        }
                    )
                }
            }).sheet(isPresented: $isSheetPresented) {
                AddReservation(viewModel: viewModel, showSheet: $isSheetPresented)
                
                
            }
        }
    }
}

/// ITEMS DESIG
struct itemReservations: View{
    var data: ReservationsResponse
    @ObservedObject var mviewModel: ResidentViewModel
    
    var body: some View{
        HStack {
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 40, height: 40)
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .padding(.leading, 5)
            
            
            VStack(alignment: .leading, spacing: 5.0, content: {
                Text("\(data.placeReservation)")
                    .font(.body).fontWeight(.semibold)
                    .foregroundColor(.primary)
                HStack {
                    Text("Por ")
                        .font(.body).fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text("\(data.personReservation)")
                        .font(.body)
                    .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Fecha: ")
                        .font(.body).fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text("\(data.date)")
                        .font(.body)
                    .foregroundColor(.secondary)
                }
                
            }).padding(.leading,5).padding(.vertical,10)
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
                mviewModel.selectedReservation = data
                mviewModel.showPopupReservation = true
            }
        }

    }
}

