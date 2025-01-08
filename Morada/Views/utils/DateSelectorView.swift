//
//  DateSelectedView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 22/10/24.
//

import SwiftUI

struct DateSelectorView: View {
    @Binding var selectedDate: Date  // Enlace a la fecha seleccionada fuera del componente
    var title: String = "Selecciona una fecha"  // Título opcional

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())  // Estilo de calendario gráfico
                .labelsHidden()  // Oculta el título por defecto
                .accentColor(.purple)  // Cambia el color de acentuación si es necesario
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)
        }
    }
}
