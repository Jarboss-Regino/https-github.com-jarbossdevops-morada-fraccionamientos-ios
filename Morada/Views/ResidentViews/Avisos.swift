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

