//
//  PopupDatePicker.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 22/10/24.
//

import Foundation
import SwiftUI

@ViewBuilder
func PopupDatePicker(selection: Binding<Date>, title: String, displayedComponents: DatePickerComponents = .date, onClose: @escaping () -> Void) -> some View {
    VStack {
        
        DatePicker(title, selection: selection, displayedComponents: displayedComponents)
            .datePickerStyle(GraphicalDatePickerStyle())
            .accentColor(.purple)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
        
        Button("Aceptar") {
            withAnimation {
                onClose()
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    .padding()
}
