//
//  EmptyView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 20/11/24.
//

import SwiftUI

struct EmptyView: View {
    //@Binding var path: [Routes]
    var body: some View {
        Button(action: {
            //path.removeLast()
        }, label: {
            Text("Regresar")
        })
    }
}

//#Preview {
//    EmptyView(path: [R])
//}
