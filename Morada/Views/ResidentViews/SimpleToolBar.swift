//
//  SimpleToolBar.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 05/11/24.
//

import SwiftUI

struct SimpleToolBar: View {
    let title: String

    var body: some View {
        HStack {
            
            Spacer()
            
            Text(title)
                .font(.largeTitle)
            
            Spacer()
            
            
        }
        .padding(.horizontal,16)
    }
}

#Preview {
    SimpleToolBar(title: "Avisos")
}
