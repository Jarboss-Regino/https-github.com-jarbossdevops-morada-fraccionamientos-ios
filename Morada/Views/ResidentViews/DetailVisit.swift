//
//  DetailVisit.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 12/11/24.
//

import SwiftUI

struct DetailVisit: View {
    @ObservedObject var viewModel = AccessViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                VStack{
                    
                    // body
                    bodyViewDetail(viewModel: viewModel)
                    
                    
                }.frame(maxWidth: .infinity).padding(.horizontal, 32)
                    .toolbar(content: {
                        ToolbarItem(placement: .principal) {
                            ToolBarBack(title: "Registro de visitante", dismissAction: {dismiss()})
                        }
                    }).navigationBarBackButtonHidden(true)
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear{
                            //viewModel.filteredVisitas = viewModel.registros
                            
                            Task{
                                viewModel.changeTitle(title:"Bitácora")
                                viewModel.changeColor(active: 1)
                                await viewModel.fetchBinnacleRegisters()
                            }
                    }
                
                if viewModel.showModal, let visita = viewModel.selectedVisita {
                    AccessDialog(isActive: $viewModel.showModal, title: "Detalles de la visita", data: visita, buttonTitle: "Compartir Qr",
                                 showButton: $viewModel.selectedButton,action: {
                        Task{
                            await viewModel.getImg(id: viewModel.selectedVisita?.evidence ?? "", uuid: viewModel.selectedVisita?.uuid ?? "")
                        }
                    })
                }
            }
            
            
        }
    }
}

struct bodyViewDetail: View {
    @ObservedObject var viewModel: AccessViewModel
    var body: some View {
        HStack{
            Button(action: {
                
                Task{
                    viewModel.changeTitle(title:"Bitácora")
                    viewModel.changeColor(active: 1)
                    await viewModel.fetchBinnacleRegisters()
                }
                
                
                print("Botón de inicio de sesión presionado")
            }) {
                Text("Bitácora")
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
            }.padding(.top, 20)
            
            
            Button(action: {
                
                Task{
                    viewModel.changeTitle(title:"Agenda")
                    viewModel.changeColor(active: 2)
                    await viewModel.fetchAgendaRegisters()
                }
                print("Botón de inicio de sesión presionado")
            }) {
                Text("Agenda")
                    .frame(maxWidth: .infinity)
                    .padding()
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
                
            }.padding(.top, 20)
            
            
        }
        
        // title toggle
        Text(viewModel.title).font(.subheadline).padding(.top,10)
        Spacer()
        
        // list
        VStack{
            
            
            if viewModel.isSearching {
                ProgressView() // Circular progress mientras se realiza la búsqueda
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                Spacer()
            } else {
                if viewModel.selectedButton == 1{
                    List(viewModel.binnacleList, id: \.id) { option in
                        ItemAgendaView(data: option, mviewModel: viewModel)
                    }.listStyle(.inset).frame(maxWidth: .infinity).scrollIndicators(.hidden)
                }else{
                    List(viewModel.registros, id: \.id) { option in
                        itemAgenta(data: option, mviewModel: viewModel)
                    }.listStyle(.inset).frame(maxWidth: .infinity).scrollIndicators(.hidden)
                }
                
            }
        }
    }
}

struct itemAgenta: View{
    var data: GetVistasResponse
    @ObservedObject var mviewModel: AccessViewModel
    var body: some View{
        
        HStack(alignment: .center, spacing: 10) {
            // Ícono único para toda la información
            Image(mviewModel.getIconName(for: data.status))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .padding(.leading,10)
                
            
            VStack(alignment: .leading){
                Text(data.name).font(.body)
                    .fontWeight(.semibold)
                .foregroundColor(.primary)
                HStack{
                    Text("Número: ")
                    Text(data.phone)
                }
                
                HStack{
                    Text("Expiración: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    Text("No aplica")
                }
                
               
                
            }
            
            Spacer()
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                mviewModel.selectedVisita = data
                mviewModel.showModal = true
            }
        }
        
        
        
        
    }
}

#Preview {
    DetailVisit()
}
