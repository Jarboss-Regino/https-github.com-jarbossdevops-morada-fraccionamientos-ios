//
//  ButtonIcon.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 05/11/24.
//

import SwiftUI

struct ButtonIcon: View {
    let icon: String
    let title: String
    
    var body: some View{
        HStack {
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .padding(.leading, 10)
            
            Text(title)
                .padding()
                .foregroundColor(.black)
                .font(.headline)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.top, 30)
        .padding(.horizontal, 32)
        .shadow(radius: 5)
            
    }
}


