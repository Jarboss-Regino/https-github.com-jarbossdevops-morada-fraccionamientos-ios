//
//  CustomDialogEvent.swift
//  Morada
//
//  Created by MacBook Air on 28/01/25.
//

import SwiftUI

struct CustomDialogEvent: View {
    @Binding var isActive: Bool
    var data: Evento
    @State private var offset: CGFloat = 1000
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack {
                Text("Detalles del Evento")
                    .font(.title2)
                    .bold()
                    .padding()
                
                HStack {
                    Text("Título : ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.tittle)")
                    Spacer()
                }
                
                HStack {
                    Text("Reservado por: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.name)")
                    Spacer()
                }
                
                
                
                HStack {
                    Text("Fecha: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.formatDate ?? "N/A")")
                    Spacer()
                }
                
                HStack {
                    Text("Descripción: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.description)")
                    Spacer()
                }
                
                
                
                
                
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing) {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
    }
}


