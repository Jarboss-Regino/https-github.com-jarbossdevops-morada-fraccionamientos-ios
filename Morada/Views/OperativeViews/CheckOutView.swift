//
//  CheckOutView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 02/10/24.
//

import SwiftUI



struct CheckOutView: View {
    
    @ObservedObject var viewModel = CheckOutViewModel()
    
    
    var body: some View {
        
        ZStack{
            VStack{
                
                VStack {
                    Text("Salidas").font(.largeTitle)
                    TextField("Buscar...", text: $viewModel.searchText)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    .cornerRadius(16)
                    .onSubmit {
                        Task{
                            if !viewModel.searchText.isEmpty{
                                await viewModel.startSearch()
                            }
                                
                        }
                    }
                    
                    LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(height: 2)
                }
                
                
                // toggles
                HStack{
                    Button(action: {
                        
                        Task{
                            viewModel.changeTitle(title:"Bitácora")
                            viewModel.changeColor(active: 1)
                            await viewModel.fetchBinnacleRegisters()
                        }
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
                Text(viewModel.title).font(.subheadline).padding(.top,10)
                Spacer()
                
                VStack{
                    
                    
                    if viewModel.isSearching {
                        ProgressView() // Circular progress mientras se realiza la búsqueda
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Spacer()
                    } else {
                        List(viewModel.registros, id: \.id) { option in
                            item(data: option, mviewModel: viewModel)
                        }.listStyle(.inset).frame(maxWidth: .infinity).scrollIndicators(.hidden)
                    }
                }
                
                
                
                
                
            }.frame(maxWidth: .infinity, maxHeight:  .infinity)
                .padding(.horizontal,16)
                .padding(.horizontal)
                .onAppear{
                    //viewModel.filteredVisitas = viewModel.registros
                    
                    Task{
                        viewModel.changeTitle(title:"Bitácora")
                        viewModel.changeColor(active: 1)
                        
                    }
                }
            
            if viewModel.showModal, let visita = viewModel.selectedVisita {
                CustomDialog(isActive: $viewModel.showModal, title: "Detalles de la visita", data: visita, buttonTitle: "Marcar salida", action: {
                    print("saliendo...")
                })
            }
           
        }
        
        
    }
}

struct item: View{
    var data: CheckOutResponse
    @ObservedObject var mviewModel: CheckOutViewModel
    var body: some View{
        VStack{
            HStack{
                Text(data.name)
                Spacer()
                Text(data.typeVisit)
            }.padding(5)
            HStack{
                Text(data.visit)
                
                Spacer()
                Text(data.address)
            }.padding(5)
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
    CheckOutView()
}
