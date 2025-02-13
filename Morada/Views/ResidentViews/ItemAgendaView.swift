//
//  ItemAgendaView.swift
//  Morada
//
//  Created by MacBook Air on 13/02/25.
//

import SwiftUI

struct ItemAgendaView: View {
    var data: CheckOutResponse
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
                mviewModel.selectedBinnacle = data
                mviewModel.showModal = true
            }
        }
        
        
        
        
    }
}


