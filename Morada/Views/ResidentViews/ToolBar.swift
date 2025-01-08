//
//  ToolBar.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 04/11/24.
//

import SwiftUI

struct ToolBar: View {
    let title: String
    let trailingAction: (() -> Void)?

    var body: some View {
        HStack {
            
            Spacer()
            
            Text(title)
                .font(.largeTitle)
            
            Spacer()
            
            if let trailingAction = trailingAction {
                Button(action: trailingAction) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 30, height: 30)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
            }
        }
        .padding(.horizontal,16)
    }
}
