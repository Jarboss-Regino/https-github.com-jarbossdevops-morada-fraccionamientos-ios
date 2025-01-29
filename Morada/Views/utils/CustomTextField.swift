//
//  CustomTextField.swift
//  Morada
//
//  Created by MacBook Air on 24/01/25.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
        @Binding var text: String

        var body: some View {
            VStack(spacing: 4) {
                TextField(placeholder, text: $text)
                    .padding(8)
                    .cornerRadius(16)
                    
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 2)
            }
            .frame(height: 60)
        }
}


