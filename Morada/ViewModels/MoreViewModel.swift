//
//  TestViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 25/09/24.
//

import Foundation
import UIKit
class MoreViewModel: ObservableObject{
    
    @Published var base64Image: String?
    
    @Published var tipo: Int?
    var mtipo: Int?
    
    @Published var refreshTrigger = false
    
    @Published var events: [Evento] = []
    @Published var filteredEvents: [Evento] = []
    @Published var selectedDate = Date()
    @Published var isVisibleButtonDelEvent: Bool = true
    
    @Published var selectedEvent: Evento? = nil
    @Published var showPopupEvent: Bool = false
   
    @Published var idEvent: String = ""
    @Published var disableButton = false
    
    // Incidents variables
    @Published var fetchDate = Date()
    @Published var textSearchData: String = ""
    @Published var isLoadingIncidents: Bool = false
    @Published var incidents: [IncidentsResponse] = []
    @Published var selectedIncident: IncidentsResponse? = nil
    @Published var showPopupIncident: Bool = false
    @Published var classification: String = ""
    
    // Add Incidentes variables
    @Published var description: String = ""
    @Published var incidentComment: String = ""
    @Published var selectedClassication: ClassificationItem? = nil
    @Published var classificationItems: [ClassificationItem] = [ClassificationItem(id: "1", name: "Mantenimiento"),ClassificationItem(id: "2", name: "Áreas comunes"),ClassificationItem(id: "3", name: "Sugerencias")]
    
    @Published var isLoadingIncident = false
    @Published var showErrorIncident = false
    @Published var errorMessageIncident = ""
    
    @Published var showMessageIncident = false
    @Published var successMessageIncident = ""
    
    @Published var disableButtonIncident = false
    
    // Reservaciones variables
    @Published var selectedButton: Int = 1 // 1 = todos, 2 = mis reservaciones
    @Published var titleList: String = "Todos"
    @Published var isLoadingReservations: Bool = false
    @Published var showPopupReservation: Bool = false
    @Published var selectedReservation: ReservationsResponse? = nil
    @Published var reservationsItems: [ReservationsResponse] = []
    @Published var placeReservation: String = ""
    @Published var comments: String = ""
    @Published var residentsList: [ResidentResponse] = []
    @Published var selectedResident: ResidentResponse? = nil
    @Published var totalPeople: Int = 1
    @Published var dateReservation = Date()
    @Published var startTimeReservation = Date()
    @Published var endTimeReservation = Date()
    @Published var isLoadingReservation = false
    @Published var showErrorReservation = false
    @Published var errorMessageReservation = ""
    @Published var disableButtonReservation: Bool = false
    
    
    @Published var showMessageReservaton = false
    @Published var successMessageReservation = ""
    
    
    // AVISOS VARIABLES
    @Published var avisosEvents: [AvisoResponse] = []
    @Published var avisosFilteredEvents: [AvisoResponse] = []
    @Published var avisoSelected: AvisoResponse? = nil
    @Published var showPopupAviso = false
    
    @Published var placeAviso = ""
    @Published var descriptionAviso = ""
    
    @Published var showErrorAviso = false
    @Published var errorMsgAviso = ""
    
    @Published var showSuccessAviso = false
    @Published var successMsgAviso = ""
    
    
    private let apiService = ApiService()
    @Published var showButtonBack = true
    
    @Published var tipoUsuario: String?
    let idUser = UserSession.shared.userData?.uuid
    let username = UserSession.shared.userData?.username
    let uuidAdmin = UserSession().userData?.uuidSuperAdmin
    let idAssignedValue: String = {
        switch UserSession.shared.userData?.idAssigned{
        case .string(let value):
            return value
        case .array(let values):
            return values.joined(separator: ",") // Une los elementos del array como una cadena separada por comas
        case .none:
            return ""
        }
    }()
    
    
    init(){
        self.tipo = UserSession.shared.userResponse?.tipo
        if let ttipo = tipo {
            mtipo = ttipo
            if ttipo == 0{
                self.isVisibleButtonDelEvent = false
                self.showButtonBack = false
            }
            let message = String(ttipo)
            print(message)
        } else {
            print("El tipo es nil")
        }
        
        self.tipoUsuario = UserSession.shared.userData?.access
        if let tipoUsuario = tipoUsuario {
            print("Usuario: " + tipoUsuario )
        }else{
            print("error al obtener el tipo de usuario")
        }
        
    }
    
    func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
  
    func logout() {
        
        UserSession.shared.logoutApp()
        
        
    }
    
    @MainActor
    func getEvents() async{
        do{
            
            let response: [Evento] = try await apiService.get(urlString: ApiEndpoints.getEventosUrl(uuid: self.idUser!))
            
            if !response.isEmpty{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                self.events = response.compactMap { registro in
                    if let mfechaEvento = dateFormatter.date(from: registro.dateI) {
                        
                        return Evento(
                            id: registro.id,
                            user: registro.user,
                            persons: registro.persons,
                            tittle: registro.tittle,
                            description: registro.description,
                            uuid: registro.uuid,
                            uuidSuperAdmin: registro.uuidSuperAdmin,
                            idAssigned: registro.idAssigned,
                            v: registro.v,
                            assigned: registro.assigned,
                            name: registro.name,
                            lastName: registro.lastName,
                            dateI: formatTimeOnly(registro.dateI),
                            dateF: formatTimeOnly(registro.dateF),
                            fechaEvent: mfechaEvento,
                            formatDate: formatDate(registro.dateI),
                            realDate: registro.dateI
                        )
                        
                    } else {
                        
                        return nil
                    }
                }
                
                self.refreshTrigger.toggle()
                filterEvents()
            }else{
                print("No hay eventos")
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
    func filterEvents() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Ajusta el formato si es necesario
        
        self.filteredEvents = self.events.filter {
            guard let eventDate = dateFormatter.date(from: $0.realDate ?? "") else {
                return false
            }
            return Calendar.current.isDate(eventDate, inSameDayAs: self.selectedDate)
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
    
   
    
    // INCIDENTS
    
    @MainActor
    func getIncidents() async{
        do {
            self.isLoadingIncidents = true
            let response: [IncidentsResponse] = try await apiService.get(urlString: ApiEndpoints.getIncidentsUrl(idUuid: self.idUser!))
            
            
            
            if !response.isEmpty{
                
                let incidentesProcesados = response.map { incident in
                    return IncidentsResponse(
                        id: incident.id,
                        user: incident.user,
                        classification: incident.classification,
                        description: incident.description,
                        evidence: ApiEndpoints.getImageUrl(img: incident.evidence, uuid: self.idUser!),
                        comments: incident.comments,
                        status: incident.status,
                        uuid: incident.uuid,
                        uuidSuperAdmin: incident.uuidSuperAdmin,
                        idAssigned: incident.idAssigned,
                        v: incident.v,
                        assigned: incident.assigned,
                        name: incident.name,
                        lastName: incident.lastName,
                        date: formatDate(incident.date)
                    )
                }
                
                self.incidents.removeAll()
                self.incidents = incidentesProcesados
                self.isLoadingIncidents = false
            }else{
                print("no hay incidentes")
                self.isLoadingIncidents = false
            }
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            self.isLoadingIncidents = false
        } catch {
            self.isLoadingIncidents = false
            print("ERROR: \(error)")
            
        }
    }
    
    
    
    @MainActor
    func fetchIncidentsByDate() async{

        self.isLoadingIncidents = true
            
        
        if !incidents.isEmpty {
            let filteredIncidents = incidents.filter { incident in
                incident.date == formatDateToString(self.fetchDate, format: "dd-MMM-yyyy")
            }
            
            if filteredIncidents.isEmpty {
                print("No se encontró ninguna incidencia con la fecha seleccionada.")
            } else {
                self.incidents = filteredIncidents
                print("Incidencias filtradas: \(self.incidents)")
            }
        } else {
            print("No se encontró ninguna incidencia.")
        }
        

        self.isLoadingIncidents = false

    }
    
    
    // FALTA POR TERMINAR ESTA FUNCIONALIDAD
    @MainActor
    func creaNewIncident(image: String) async{
        
        do {
            if self.selectedClassication == nil || self.description.isEmpty ||
                self.incidentComment.isEmpty{
                self.errorMessageIncident = "Todos los campos son obligatorios"
                self.showErrorIncident = true
                return
            }
            let body = NewIncidentRequest(
                user: self.username ?? "",
                classification: self.selectedClassication?.name ?? "",
                description: self.description,
                comments: self.incidentComment,
                status: "",
                date: Utils.getDateHour(),
                uuidSuperAdmin: self.uuidAdmin ?? "",
                uuid: self.idUser ?? "",
                idAssigned: self.idAssignedValue,
                evidence: image
            )
            
            
            let response: NewIncidenteResponse = try await apiService.postJson(urlString: ApiEndpoints.createIncidentUrl, body: body)
            
            
            
            if response.message == "Incidence created successfully"{
                print(response.message)
                self.showErrorIncident = false
                self.successMessageIncident = "Incidencia creada correctamente"
                self.showMessageIncident = true
                resetIncidentFields()
            }else{
                print("Error: No se pudo crear la incidencia")
                self.showMessageIncident = false
                self.errorMessageIncident = "No se pudo crear la incidencia"
                self.showErrorIncident = true
               
            }
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            
        } catch {
            
            print("ERROR: \(error)")
            
        }
    }
    func resetIncidentFields(){
        self.selectedClassication = nil
        self.description = ""
        self.incidentComment = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showErrorIncident = false
            self.showMessageIncident = false
        }
    }
    
    func getClassificacion(type: String) -> String{
        switch type {
        case "1":
            return "Mantenimiento"
        case "2":
            return "Áreas comunes"
        case "3":
            return "Sugeriencias"
        default:
            return "N/A"
        }
    }
    
    func getDateFormatter(fecha: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: fecha)
    }
    
    /// Reservations func
    
    
    @MainActor
    func getReservations() async {
        do{
            self.isLoadingReservations = true
                 
            let response: [ReservationsResponse] = try await apiService.get(urlString: ApiEndpoints.getReservationsUrl(idUser: self.idUser!))
            
                      
            
            if !response.isEmpty{
                
                let reservacionesProcedados = response.map{reservation in
                    return ReservationsResponse(
                        id: reservation.id,
                        placeReservation: reservation.placeReservation,
                        hourI: formatTimeOnly(reservation.hourI),
                        hourF: formatTimeOnly(reservation.hourF),
                        persons: reservation.persons,
                        comments: reservation.comments,
                        personReservation: reservation.personReservation,
                        uuid: reservation.uuid,
                        uuidSuperAdmin: reservation.uuidSuperAdmin,
                        idAssigned: reservation.idAssigned,
                        idResident: reservation.idResident,
                        idAdministrative: reservation.idAdministrative,
                        idOperative: reservation.idOperative,
                        v: reservation.v,
                        assigned: reservation.assigned,
                        name: reservation.name,
                        lastName: reservation.lastName,
                        date: formatDate(reservation.date)
                    )
                    
                }
                
                
                self.reservationsItems.removeAll()
                self.reservationsItems = reservacionesProcedados
                print(reservationsItems)
                
            }else{
                print("No hay Reservaciones")
            }
            
            self.isLoadingReservations = false
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            self.isLoadingReservations = false
        } catch {
            self.isLoadingReservations = false
            print("ERROR: \(error)")
            
        }
    }
    
    @MainActor
    func getResidents() async{
//        'do{
//            let idSucursal = UserSession.shared.userResponse?.idCliente ?? ""
//
//
//            let body = ResidentRequest(source1: idSucursal)
//
//            let response: [ResidentResponse] = try await apiService.post(urlString: ApiEndpoints.getResidentsUrl, body: body)
//
//            if !response.isEmpty{
//                let residentesProcesados = response.map { residente in
//                    return ResidentResponse(id: residente.id, nombre: residente.nombre)
//                }
//                self.residentsList.removeAll()
//                self.residentsList = residentesProcesados
//            }else{
//                print("No hay residentes")
//            }
//
//
//
//        }catch let error as ApiError {
//
//
//            print("Error: \(error)")
//
//
//        } catch {
//
//            print("Error desconocido")
//
//        }
    }
    
    @MainActor
    func createReservation() async {
        do{
            self.isLoadingReservation = true
            if self.placeReservation.isEmpty || self.comments.isEmpty {
                self.errorMessageReservation = "Todos los campos son obligatorios"
                self.showErrorReservation = true
                return
            }
            if self.comments.isEmpty {
                self.errorMessageReservation = "Todos los campos son obligatorios"
                self.showErrorReservation = true
                return
            }
            
            
            let personReservation = UserSession.shared.userData?.username
            let uuidSuperAdmin = UserSession.shared.userData?.uuidSuperAdmin
            let uuid = UserSession.shared.userData?.uuid
            
            let idAssignedValue: String = {
                switch UserSession.shared.userData?.idAssigned{
                case .string(let value):
                    return value
                case .array(let values):
                    return values.joined(separator: ",") // Une los elementos del array como una cadena separada por comas
                case .none:
                    return ""
                }
            }()
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let start = timeFormatter.string(from: self.startTimeReservation)
            let end = timeFormatter.string(from: self.endTimeReservation)
            
            let people = String(self.totalPeople)

            let body = SetReservationRequest(
                placeReservation: self.placeReservation.trimmingCharacters(in: .whitespaces),
                hourI: start,
                hourF: end,
                persons: people,
                comments: self.comments.trimmingCharacters(in: .whitespaces),
                personReservation: personReservation!,
                date: getDateFormatter(fecha: dateReservation),
                uuidSuperAdmin: uuidSuperAdmin!,
                uuid: uuid!,
                idAssigned: idAssignedValue
            )
            
            let response: NewReservationResponse = try await apiService.postJson(urlString: ApiEndpoints.setReservationUrl, body: body)
            
            if response.message == "Reservation created successfully"{
                self.showErrorReservation = false
                self.errorMessageReservation = ""
                
                
                self.successMessageReservation = "Reservación registrada"
                self.showMessageReservaton = true
                self.disableButtonReservation = true
            }else{
                self.errorMessageReservation = "Ocurrio un error"
                self.showErrorReservation = true
                self.disableButtonReservation = false
            }
            self.isLoadingReservation = false
        }catch let error as ApiError {
            
            self.isLoadingReservation = false
            print("Error: \(error)")
                
            
        } catch {
            self.isLoadingReservation = false
            print("Error desconocido")
            
        }
    }
    
    @MainActor
    func resetFieldsReseravation() {
        self.disableButtonReservation = false
        self.showErrorReservation = false
        self.errorMessageReservation = ""
        self.totalPeople = 1
        self.showMessageReservaton = false
        self.successMessageReservation = ""
        self.dateReservation = Date()
        self.startTimeReservation = Date()
        self.endTimeReservation = Date()
        self.comments = ""
        self.placeReservation = ""
        self.selectedResident = nil
    }
    
    // AVISOS FUNCS
    @MainActor
    func getAvisos() async{
        do{
            let response: [AvisoResponse] = try await apiService.get(urlString: ApiEndpoints.getAvisosUrl(uuid: self.idUser ?? ""))

            if !response.isEmpty{

                let avisoProcesados = response.map{ aviso in
                        return AvisoResponse(
                            id: aviso.id,
                            userName: aviso.userName,
                            description: aviso.description,
                            place: aviso.place,
                            adjunto: ApiEndpoints.getImageAviso(img: aviso.adjunto, idAssigned: aviso.idAssigned.getStringValue()),
                            uuid: aviso.uuid,
                            uuidSuperAdmin: aviso.uuidSuperAdmin,
                            idAssigned: aviso.idAssigned,
                            v: aviso.v,
                            assigned: aviso.assigned,
                            name: aviso.name,
                            lastName: aviso.lastName,
                            date: formatDate(aviso.date),
                            hour: formatTimeOnly(aviso.date)
                        )
                }
                
                self.avisosEvents.removeAll()
                self.avisosEvents = avisoProcesados
                print("get events ejecutado")
                
                
                //AvisoFilterEvents()
            }else{
                print("No hay eventos en avisos")
            }
            
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            
        } catch {
            
            print("ERROR: \(error)")
            
        }
    }
    
    @MainActor
    func createAviso(image: String) async {
        do{
            self.errorMsgAviso = "Todos los campos deben llernarse"
            self.successMsgAviso = "Aviso creado correctamente"
            
            
            if self.placeAviso.isEmpty{
                self.showSuccessAviso = false
                self.showErrorAviso = true
                return
            }
            if self.descriptionAviso.isEmpty{
                self.showSuccessAviso = false
                self.showErrorAviso = true
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let currentDate = dateFormatter.string(from: Date())
            
            let idAssignedValue: String = {
                switch UserSession.shared.userData?.idAssigned{
                case .string(let value):
                    return value
                case .array(let values):
                    return values.joined(separator: ",") // Une los elementos del array como una cadena separada por comas
                case .none:
                    return ""
                }
            }()
            
            let body = AvisoRequest(
                userName: self.username!,
                description: self.descriptionAviso,
                place: self.placeAviso,
                date: currentDate,
                uuidSuperAdmin: self.uuidAdmin!,
                uuid: self.idUser!,
                idAssigned: idAssignedValue,
                adjunto: image
            )
            
            let response: NewAvisoResponse = try await apiService.postJson(urlString: ApiEndpoints.setAvisoUrl, body: body)

            if response.message == "Notice created successfully"{
                self.showSuccessAviso = true
                self.showErrorAviso = false
                self.placeAviso = ""
                self.descriptionAviso = ""
            }else{
                print("Ocurrio un error")
                self.showSuccessAviso = false
                self.errorMsgAviso = "Ocurrio un error"
                self.showErrorAviso = true
            }
            
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            
        } catch {
            
            print("ERROR: \(error)")
            
        }
    }
    
    func resetAvisoFields(){
        self.placeAviso = ""
        self.descriptionAviso = ""
        self.showErrorAviso = false
        self.showSuccessAviso = false
        self.errorMsgAviso = ""
        self.successMsgAviso = ""
    }
    
    func generateTemporaryImage() -> String? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let imageData = image?.jpegData(compressionQuality: 0.8) {
            return imageData.base64EncodedString()
        }
        return nil
    }
    
    @MainActor
    func AvisoFilterEvents() {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Ajusta el formato si es necesario
        
//        self.avisosFilteredEvents = self.avisosEvents.filter {
//            guard let eventDate = dateFormatter.date(from: $0.fecha) else {
//                return false
//            }
//            return Calendar.current.isDate(eventDate, inSameDayAs: self.avisoSelectedDate)
//        }
    }
    
    @MainActor
    func changeTitle(title: String) {
        self.titleList = title
        
    }
    
    @MainActor
    func changeColor(active: Int) {
        
        self.selectedButton = active
        
    }
    func formatTimeOnly(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Formato de entrada solo para la hora (24 horas)
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h:mm a" // Formato de salida (12 horas con AM/PM)
            return dateFormatter.string(from: date)
        }else {
            print("Error: El formato de la cadena no coincide con el formato esperado.")
        }
        return ""
    }
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Formato de entrada
        if let date = dateFormatter.date(from: dateString) {
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "dd-MMM-yyyy" // Formato de salida (día-mes-año)
            customFormatter.locale = Locale(identifier: "es_MX") // Configurar el idioma a español
            return customFormatter.string(from: date)
        }
        return ""
    }
    func formatDateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func convertToBase64(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            base64Image = imageData.base64EncodedString()
        }
    }
}
