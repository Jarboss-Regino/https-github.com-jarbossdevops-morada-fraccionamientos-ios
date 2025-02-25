//
//  AvisosView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 31/10/24.
//

import SwiftUI

struct AvisosView: View {
    @ObservedObject var viewModel: MoreViewModel
    @State private var isActive = false
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    var body: some View {
        //NavigationStack{
            VStack{
                List(viewModel.avisosEvents, id: \.id) { option in
                    itemAvisosViews(data: option,viewModel: viewModel)
                }.listStyle(.inset).frame(maxWidth: .infinity).padding(.horizontal,32).padding(.top,10).scrollIndicators(.hidden).refreshable {
                    Task{
                        
                        await viewModel.getAvisos()
                    }
                }
      
            }.frame(maxWidth: .infinity, maxHeight: .infinity).onAppear{
                Task{
                    await viewModel.getAvisos()
                }
            }.overlay(
                Group{
                    if viewModel.showPopupAviso, let aviso =
                        viewModel.avisoSelected {
                        CustomDialogAvisos(isActive: $viewModel.showPopupAviso, data: aviso).onDisappear{
                            Task{
                                await viewModel.getAvisos()
                            }
                        }
                    }
                }
            ).toolbar(content: {
                ToolbarItem(placement: .principal) {
                        CustomToolbar(
                            title: "Avisos",
                            dismissAction: {
                                dismiss()
                                
                            },
                            trailingAction: {
                                isSheetPresented = true
                            }
                        
                        )
                    }
            }).navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $isSheetPresented) {
                    AddAvisoView(viewModel: viewModel).onDisappear{
                        Task{
                            viewModel.resetAvisoFields()
                            await viewModel.getAvisos()
                        }
                    }
                }
                
        //}
        }
}

struct itemAvisosViews:View {
    var data: AvisoResponse
    @ObservedObject var viewModel: MoreViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Usuario:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(data.userName)
                    .font(.body)
                    .foregroundColor(.primary)
                Text("Lugar:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(data.place)
                    .font(.body)
                    .foregroundColor(.primary)
                Text("Fecha:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("\(data.date) \(data.hour ?? "00:00")")
                    .font(.body)
                    .foregroundColor(.primary)
            }.padding()
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
                viewModel.avisoSelected = data
                viewModel.showPopupAviso = true
            }
        }
    }
}


