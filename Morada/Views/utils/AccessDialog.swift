//
//  AccessDialog.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 13/11/24.
//

import SwiftUI

struct AccessDialog: View {
    @Binding var isActive: Bool

    let title: String
    let data: DetailVisitas
    let buttonTitle: String
    @Binding var showButton: Int
    let action: () -> ()
    @State private var offset: CGFloat = 1000

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }

            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()

                HStack(alignment: .center){
                    Text("Nombre:").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    Text("\(data.nombre)")
                }
                
                HStack(alignment: .center){
                    Text("Asunto:").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.tipovis)")
                }
                
                
                HStack(alignment: .center){
                    Text("Fecha de la visita:").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    Text("\(data.fecha)")
                }
                
                
                
                HStack(alignment: .center){
                    Text("Hora:").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    Text("\(data.hora)")
                }
                

                if showButton != 1{
                    Button {
                        action()
                        close()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.red)

                            Text(buttonTitle)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding()
                    }
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


