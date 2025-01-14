//
//  CustomDialogIncident.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 17/10/24.
//

import SwiftUI

struct CustomDialogIncident: View {
    @Binding var isActive: Bool
    var data: IncidentsResponse
    @State private var offset: CGFloat = 1000
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack {
                Text("Detalles del incidente")
                    .font(.title2)
                    .bold()
                    .padding()
                
                HStack {
                    Text("Clasificación: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.classification)")
                    Spacer()
                }
                
                HStack {
                    Text("Descripción: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.description)")
                    Spacer()
                }
                
                HStack {
                    Text("Fecha: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.date)")
                    Spacer()
                }
                
                HStack {
                    Text("Comentarios: ").font(.body)
                        .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("\(data.comments)")
                    Spacer()
                }
                
                AsyncImage(url: URL(string: data.evidence)) { phase in
                    switch phase {
                    case .empty:
                        // Aquí puedes mostrar un indicador de carga
                        ProgressView()
                    case .success(let image):
                        // La imagen se cargó con éxito
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    case .failure:
                        // En caso de error, muestra una imagen por defecto o un mensaje
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        // Fallback en caso de un estado inesperado
                        Image(systemName: "exclamationmark.triangle")
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


