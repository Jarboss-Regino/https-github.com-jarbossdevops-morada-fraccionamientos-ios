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
                Text(data.tittle)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(data.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(data.realDate ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
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
}

