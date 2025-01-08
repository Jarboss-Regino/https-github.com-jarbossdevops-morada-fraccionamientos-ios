//
//  CalendarView.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 11/10/24.
//

import Foundation

import SwiftUI
import UIKit
protocol CalendarEventProtocol {
    var fechaEvent: Date? { get }
}

// Representable para UICalendarView
struct CalendarView<T: CalendarEventProtocol>: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var events: [T] // Fechas de eventos
    private var refreshID = UUID()
    
    init(selectedDate: Binding<Date>, events: Binding<[T]>) {
            _selectedDate = selectedDate
            _events = events
            // Crear un identificador único cada vez que los eventos cambian
            refreshID = UUID()
        }

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Invalida el diseño actual del calendario
        uiView.reloadInputViews()
        uiView.invalidateIntrinsicContentSize()
        
        // Obtiene el mes y el año actual desde la fecha seleccionada
        let currentMonth = Calendar.current.component(.month, from: selectedDate)
        let currentYear = Calendar.current.component(.year, from: selectedDate)
        
        // Filtra los eventos solo para el mes actual
        let eventsForCurrentMonth = events.compactMap { $0.fechaEvent }.map {
            Calendar.current.dateComponents([.year, .month, .day], from: $0)
        }.filter { $0.year == currentYear && $0.month == currentMonth }
        
        // Si hay eventos, actualiza las decoraciones
        if !eventsForCurrentMonth.isEmpty {
            uiView.reloadDecorations(forDateComponents: eventsForCurrentMonth, animated: true)
        }
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        // Proporciona una decoración para las fechas de eventos
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            guard let date = dateComponents.date else { return nil }
                
                // Aquí simplemente verificamos si la fecha de los eventos contiene el día específico
                if parent.events.contains(where: { Calendar.current.isDate($0.fechaEvent!, inSameDayAs: date) }) {
                    return .default(color: .red, size: .large)
                }
                return nil
        }

        // Maneja la selección de una fecha
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                parent.selectedDate = date
            }
        }
    }
}
