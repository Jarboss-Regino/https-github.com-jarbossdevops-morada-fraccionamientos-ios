//
//  Access.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 05/11/24.
//

import SwiftUI

struct AccessView: View {
    
    var body: some View {
        //NavigationStack{
            VStack{
                NavigationLink(destination: RegisterVisitView().navigationBarBackButtonHidden(true)){
                    defaultButton(icon: "camera.fill", title: "Registro de visitas")
                }
               
                NavigationLink(destination: DetailVisit().navigationBarBackButtonHidden(true)){
                    defaultButton(icon: "camera.fill", title: "Bitácora de entradas")
                }
                
                Spacer()
            }.toolbar(content: {
                ToolbarItem(placement: .principal) {
                    SimpleToolBar(title: "Accesos")
                }
            }).navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
       // }
    }
}

#Preview {
    AccessView()
}
