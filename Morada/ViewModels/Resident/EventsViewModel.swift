//
//  EventsViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 05/11/24.
//

import Foundation

class EventsViewModel: ObservableObject{
    // EVENT VARIABLES
    @Published var refreshTrigger = false
    
    @Published var events: [Evento] = []
    @Published var filteredEvents: [Evento] = []
    @Published var selectedDate = Date()
    @Published var isVisibleButtonDelEvent: Bool = true
    // add event variables
    @Published var numPeople: Int = 1
    @Published var date = Date()
    @Published var startTime = Date()
    @Published var endTime = Date()
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var showMessage = false
    @Published var successMessage = ""
    
    @Published var disableButton = false
    
    @Published var idEvent: String = ""
    
    private let apiService = ApiService()
    var mtipo: Int?
    
    
    init(){
//        var type = UserSession.shared.userResponse?.tipo
//        if let ttipo = type {
//            mtipo = ttipo
//            
//        } else {
//            print("El tipo es nil")
//        }
    }
    /// EVENTS FUNCS
    
    @MainActor
    func getEvents() async{
//        do{
//            var id: String = "0"
//            if mtipo != 0{
//                id = (UserSession.shared.userResponse?.idCliente)!
//            }
//            let body = EventRequest(source1: "0", source2: id)
//            
//            
//            let response: EventResponse = try await apiService.post(urlString: ApiEndpoints.getEventosUrl, body: body)
//            
//            if !response.registros.isEmpty{
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                
//                self.events = response.registros.compactMap { registro in
//                    if let mfechaEvento = dateFormatter.date(from: registro.fechaEvento) {
//                        return Evento(id: registro.id, idUsuario: registro.idUsuario, fechaEvento: registro.fechaEvento, horaInicio: registro.horaInicio, horaFin: registro.horaFin, personas: registro.personas, comentarios: registro.comentarios, fecha: registro.fecha, estatus: registro.estatus,fechaEvent: mfechaEvento)
//                        
//                    } else {
//                        return nil
//                    }
//                }
//                print("get events")
//                self.refreshTrigger.toggle()
//                filterEvents()
//            }else{
//                print("No hay eventos")
//            }
//            
//            
//        } catch let error as ApiError {
//            // Manejar errores específicos de la API
//            DispatchQueue.main.async {
//                //self.isLoading = false
//                //self.errorMessage = "Error: \(error)"
//                //self.showError = true
//                //self.isSearching = false
//                print("ERROR: \(error)")
//            }
//        } catch {
//            // Manejar errores genéricos
//            DispatchQueue.main.async {
//                //self.isLoading = false
//                //self.errorMessage = "Ocurrió un error inesperado"
//                //self.showError = true
//                //self.isSearching = false
//                print("ERROR: \(error)")
//            }
//        }
    }
    
    @MainActor
    func filterEvents() {
//        print("filterEvents")
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" // Ajusta el formato si es necesario
//        
//        self.filteredEvents = self.events.filter {
//            guard let eventDate = dateFormatter.date(from: $0.fechaEvento) else {
//                return false
//            }
//            return Calendar.current.isDate(eventDate, inSameDayAs: self.selectedDate)
//        }
    }
    
    @MainActor
    func creaeNewEvent() async{
        do {
            let ahora = Date()
            print(ahora)
            
            
            if numPeople <= 0{
                self.errorMessage = "El número de personas debe ser mayor a 0"
                self.showError = true
                return
            }
            
            self.showError = false
            guard date >= ahora else {
                self.errorMessage = "La fecha del evento debe ser en el futuro."
                self.showError = true
                return
            }
            self.showError = false
            guard startTime >= ahora else {
                self.errorMessage = "La hora de inicio debe ser mayor a la hora actual."
                self.showError = true
                return
            }
            self.showError = false
            guard endTime > ahora && endTime > startTime else {
                self.errorMessage = "La hora de finalización debe ser mayor a la hora actual y a la hora de inicio."
                self.showError = true
                return
            }
            self.isLoading = true
            var id: String = "0"
            if mtipo != 0{
                id = (UserSession.shared.userResponse?.idCliente)!
            }
            
            let idUser = (UserSession.shared.userResponse?.id)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let soloFecha = dateFormatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let start = timeFormatter.string(from: startTime)
            let end = timeFormatter.string(from: endTime)
            
            let totalPeople = String(numPeople)
            
//            let body = NewEventRequest(source1: idUser, source2: soloFecha, source3: start, source4: end, source5: totalPeople, source6: "", source7: id)
//            
//            let response: NewEventResponse = try await apiService.post(urlString: ApiEndpoints.setEventoUrl, body: body)
//            
//            
//            if response.estatus == "ok" {
//                self.isLoading = false
//                self.showError = false
//                self.disableButton = true
//                self.successMessage = "Evento reservado"
//                self.showMessage = true
//            }else{
//                self.isLoading = false
//                self.errorMessage = "Ocurrio un error al registrar el evento"
//                self.showError = true
//            }
            
            
            
        } catch let error as ApiError {
            // Manejar errores específicos de la API
            DispatchQueue.main.async {
                self.isLoading = false
                self.showError = true
                print("ERROR: \(error)")
            }
            
        } catch {
            self.isLoading = false
            self.showError = true
            print("ERROR: \(error)")
        }
    }
    
    @MainActor
    func deleteEvent() async{
        do {
            self.idEvent =  self.filteredEvents.first?.id ?? ""
            if idEvent.isEmpty{
                print("id evento vacio")
                return
            }
            print("idEvento: \(idEvent)")
            
            let body = BinnacleRequest(source1: self.idEvent)
            let response: DeleteEventResponse = try await apiService.post(urlString: ApiEndpoints.deleteEventoUrl, body: body)
            
            if response.status == "ok"{
                print("evento eliminado")
            }
            
        } catch let error as ApiError {
            // Manejar errores específicos de la API
            DispatchQueue.main.async {
                //self.isLoading = false
                //self.errorMessage = "Error: \(error)"
                //self.showError = true
                //self.isSearching = false
                print("ERROR: \(error)")
            }
        } catch {
            // Manejar errores genéricos
            DispatchQueue.main.async {
                //self.isLoading = false
                //self.errorMessage = "Ocurrió un error inesperado"
                //self.showError = true
                //self.isSearching = false
                print("ERROR: \(error)")
            }
        }
    }
    
    @MainActor
    func resetFields(){
        self.disableButton = false
        self.showError = false
        self.errorMessage = ""
        self.numPeople = 1
        self.showMessage = false
        self.successMessage = ""
        self.date = Date()
        self.startTime = Date()
        self.endTime = Date()
        
    }
}
