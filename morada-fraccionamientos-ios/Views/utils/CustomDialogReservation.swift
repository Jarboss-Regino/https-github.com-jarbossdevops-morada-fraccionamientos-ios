//
//  CustomDialogReservation.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 21/10/24.
//

import SwiftUI

struct CustomDialogReservation: View {
    @Binding var isActive: Bool
    var data: Reservations
    @State private var offset: CGFloat = 1000
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack {
                Text("Detalles de la Reservación")
                    .font(.title2)
                    .bold()
                    .padding()
                
                HStack {
                    Text("Reservación: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.reservacion)")
                    Spacer()
                }
                
                HStack {
                    Text("Comentarios: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.comentario)")
                    Spacer()
                }
                
                HStack {
                    Text("Fecha: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.fecha)")
                    Spacer()
                }
                
                HStack {
                    Text("Hora inicio: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.desde)")
                    Spacer()
                }
                
                HStack {
                    Text("Hora de terminación: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.hasta)")
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


