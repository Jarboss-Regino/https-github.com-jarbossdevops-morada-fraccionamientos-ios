//
//  ToolBarBack.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 06/11/24.
//

import SwiftUI

struct ToolBarBack: View {
    let title: String
    let dismissAction: (() -> Void)?
    var body: some View {
        HStack {
            if let dismissAction = dismissAction {
                Button(action: dismissAction) {
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        .mask(Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20))
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            Text(title)
                .font(.largeTitle)
            
            Spacer()
        }
    }
}


