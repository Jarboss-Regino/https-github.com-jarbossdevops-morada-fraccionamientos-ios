//
//  Avisos.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 04/11/24.
//

import SwiftUI

struct Avisos: View {
    @ObservedObject var viewModel: ResidentViewModel
    @State private var isActive = false
    @Environment(\.dismiss) var dismiss
    @State private var calendarID = UUID()
    
    var body: some View {
        //NavigationView{
            ZStack{
                CalendarView(
                    selectedDate: $viewModel.avisoSelectedDate,
                    events: $viewModel.avisosEvents
                ).onChange(of: viewModel.avisoSelectedDate,{
                    calendarID = UUID()
                    viewModel.AvisoFilterEvents()
                })
                    
                
                if !viewModel.avisosFilteredEvents.isEmpty {
                       VStack {
                           HStack {
                               Spacer()
                               Button {
                                   viewModel.avisosFilteredEvents = []
                               } label: {
                                   Image(systemName: "xmark")
                                       .font(.title2)
                                       .fontWeight(.medium)
                               }
                               .tint(.black)
                               .padding()
                               
                           }
                           Text("Detalles del Evento")
                               .font(.title)
                           
                           ForEach(viewModel.avisosFilteredEvents, id: \.id) { event in
                               VStack(alignment: .leading) {
                                   Text("Usuario: \(event.nombre)")
                                   Text("Fecha: \(event.fecha)")
                                   Text("Hora: \(event.hora)")
                                   Text("Lugar: \(event.lugar)")
                               }.padding(.bottom, 15)
                               
                           }
                           
                           
                          
//                           Button(action: {
//                               isActive = true
//                           }, label: {
//                               Text("Cerrar")
//                                   .font(.system(size: 16, weight: .bold))
//                                   .foregroundColor(.black)
//                                   .frame(height: 40)
//                                   .padding()
//                           })
                           
                       }
                       .frame(width: 300)
                       .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                       .shadow(radius: 5)
                   }
                
            }.toolbar(content: {
                ToolbarItem(placement: .principal) {
                    SimpleToolBar(title: "Avisos")
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity).onAppear{
                Task{
                    await viewModel.getAvisos()
                }
            }.navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        //}
    }
}

