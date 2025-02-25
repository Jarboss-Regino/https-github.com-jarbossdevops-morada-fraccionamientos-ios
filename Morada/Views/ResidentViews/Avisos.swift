//
//  Avisos.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 04/11/24.
//

import SwiftUI

struct Avisos: View {
    @ObservedObject var viewModel = MoreViewModel()
    @State private var isSheetPresented = false
    var body: some View {
        NavigationView{
            ZStack{
   
                
                List(viewModel.avisosEvents, id: \.id) { option in
                    itemAvisosViews(data: option,viewModel: viewModel)
                }.listStyle(.inset).frame(maxWidth: .infinity).padding(.horizontal,32).padding(.top,10).scrollIndicators(.hidden).refreshable {
                    Task{
                        
                        await viewModel.getAvisos()
                    }
                }.onAppear{
                    Task{
                        
                        await viewModel.getAvisos()
                    }
                }
                           
 
            }.toolbar(content: {
                ToolbarItem(placement: .principal) {
                    ToolBar(
                        title: "Avisos",
                        trailingAction: {
                            isSheetPresented = true
                        }
                    )
                }
            }).sheet(isPresented: $isSheetPresented) {
                AddAvisoView(viewModel: viewModel).onDisappear{
                    Task{
                        viewModel.resetAvisoFields()
                        await viewModel.getAvisos()
                    }
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity).onAppear{
                Task{
                    await viewModel.getAvisos()
                }
            }.navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline).overlay(
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
                )
        }
    }
}

