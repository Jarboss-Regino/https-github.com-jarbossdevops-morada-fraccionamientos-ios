//
//  DialogAgendaItemView.swift
//  Morada
//
//  Created by MacBook Air on 13/02/25.
//

import SwiftUI

struct DialogAgendaItemView: View {
    @Binding var isActive: Bool

    let title: String
    let data: GetVistasResponse
    let buttonTitle: String
    let action: () -> ()
    @State private var offset: CGFloat = 1000

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }

            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()

                Text("Visitante:").font(.title2)
                Text("\(data.name)")
                
                Text("Residente:").font(.title2).padding(.top,10)
                Text("\(data.visit)")
                
                
                Text("Domicilio:").font(.title2).padding(.top,10)
                Text("\(data.address)")
                
                Text("Tipo de Visita:").font(.title2).padding(.top,10)
                Text("\(data.typeVisit)")
                
                Text("Fecha:").font(.title2).padding(.top,10)
                Text("\(data.dateFormated ?? "")")

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


