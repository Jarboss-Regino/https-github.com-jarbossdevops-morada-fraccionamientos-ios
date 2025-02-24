//
//  ItemEventView.swift
//  Morada
//
//  Created by MacBook Air on 28/01/25.
//

import SwiftUI

struct ItemEventView: View {
    var data: Evento
    @ObservedObject var viewModel: MoreViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                infoRow(title: "Título:", value: data.tittle)
                infoRow(title: "Descripción:", value: data.description)
                infoRow(title: "Fecha:", value: data.realDate ?? "")
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
                viewModel.selectedEvent = data
                viewModel.showPopupEvent = true
            }
        }
    }
    
    @ViewBuilder
        private func infoRow(title: String, value: String) -> some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black) // Resalta el título
                
                Text(value)
                    .font(.body) // Mantiene el texto normal
                    .foregroundColor(.primary)
            }
        }
}

