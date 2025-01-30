//
//  ResidentViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 04/11/24.
//

import Foundation

class ResidentViewModel: ObservableObject{
    
    // AVISOS VARIABLES
    @Published var avisosEvents: [AvisoResponse] = []
    @Published var avisosFilteredEvents: [AvisoResponse] = []
    @Published var avisoSelectedDate = Date()
    
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
    
    
    
    
    private let apiService = ApiService()
    var mtipo: Int?
    
    let idUser = UserSession.shared.userData?.uuid
    
    // AVISOS FUNCS
    @MainActor
    func getAvisos() async{
        do{
            let response: [AvisoResponse] = try await apiService.get(urlString: ApiEndpoints.getAvisosUrl(uuid: self.idUser!))

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
                print("get avisos ejecutado")
                
                
                //AvisoFilterEvents()
            }else{
                print("No hay avisos")
            }
            
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            
        } catch {
            
            print("ERROR: \(error)")
            
        }
    }
    
    @MainActor
    func AvisoFilterEvents() {
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" // Ajusta el formato si es necesario
//        
//        self.avisosFilteredEvents = self.avisosEvents.filter {
//            guard let eventDate = dateFormatter.date(from: $0.fecha) else {
//                return false
//            }
//            return Calendar.current.isDate(eventDate, inSameDayAs: self.avisoSelectedDate)
//        }
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
                if self.selectedButton == 1 {
                    self.reservationsItems = reservacionesProcedados
                    //print(reservationsItems)
                }else{
                    
                    self.reservationsItems  = reservacionesProcedados.filter{
                        $0.uuid == self.idUser  
                    }
                    //print("Filtrados: \(self.reservationsItems)")
                }
                
                
                
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
        do{
            let idSucursal = UserSession.shared.userResponse?.idCliente ?? ""
            
            
            let body = ResidentRequest(source1: idSucursal)
            
            let response: [ResidentResponse] = try await apiService.post(urlString: ApiEndpoints.getResidentsUrl, body: body)
            
            if !response.isEmpty{
                let residentesProcesados = response.map { residente in
                    return ResidentResponse(id: residente.id, nombre: residente.nombre)
                }
                self.residentsList.removeAll()
                self.residentsList = residentesProcesados
            }else{
                print("No hay residentes")
            }
            
            
            
        }catch let error as ApiError {
            
                
            print("Error: \(error)")
                
            
        } catch {
            
            print("Error desconocido")
            
        }
    }
    
    @MainActor
    func createReservation() async {
        do{
            let ahora = Date()
            self.isLoadingReservation = true
            if self.placeReservation.isEmpty{
                self.errorMessageReservation = "Todos los campos son obligatorios"
                self.showErrorReservation = true
                self.showMessageReservaton = false
                return
            }
            self.showErrorReservation = false
            if self.comments.isEmpty {
                self.errorMessageReservation = "Todos los campos son obligatorios"
                self.showErrorReservation = true
                self.showMessageReservaton = false
                return
            }
            let calendar = Calendar.current
            let truncatedDate = calendar.startOfDay(for: dateReservation)
            let truncatedAhora = calendar.startOfDay(for: ahora)
           
            guard truncatedDate >= truncatedAhora else {
                self.errorMessageReservation = "La fecha de la reservación debe ser en el futuro."
                self.showErrorReservation = true
                self.showMessageReservaton = false
                return
            }
            self.showErrorReservation = false
            guard startTimeReservation >= ahora else {
                self.errorMessageReservation = "La hora de inicio debe ser mayor a la hora actual."
                self.showErrorReservation = true
                self.showMessageReservaton = false
                return
            }
            self.showErrorReservation = false
            guard endTimeReservation > ahora && endTimeReservation > startTimeReservation else {
                self.errorMessageReservation = "La hora de finalización debe ser mayor a la hora actual y a la hora de inicio."
                self.showErrorReservation = true
                self.showMessageReservaton = false
                return
            }
            self.showErrorReservation = false

            
            let personReservation = UserSession.shared.userData?.username
            let uuidSuperAdmin = UserSession.shared.userData?.uuidSuperAdmin
            let uuid = UserSession.shared.userData?.uuid
            var idAsignedtemp = ""
            if let assignedID = UserSession.shared.userData?.idAssigned {
                let idAssignedValue = assignedID.getStringValue()
                print("ID Assigned: \(idAssignedValue)")
                idAsignedtemp = idAssignedValue
            } else {
                print("No se encontró el valor de `idAssigned`.")
            }
            
            
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
                idAssigned: idAsignedtemp
            )
            

            let response: NewReservationResponse = try await apiService.postJson(urlString: ApiEndpoints.setReservationUrl, body: body)
            
            if response.message == "Reservation created successfully"{
                self.showErrorReservation = false
                self.errorMessageReservation = ""
                
                
                self.successMessageReservation = "Reservación registrada"
                self.showMessageReservaton = true
                self.disableButtonReservation = true
                
                self.placeReservation = ""
                self.comments = ""
            }else{
                self.errorMessageReservation = "Ocurrio un error"
                self.showErrorReservation = true
                self.disableButtonReservation = false
                self.showMessageReservaton = false
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
        dateFormatter.dateFormat = "HH:mm" // Formato de entrada solo para la hora (24 horas)
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h:mm a" // Formato de salida (12 horas con AM/PM)
            return dateFormatter.string(from: date)
        }
        return ""
    }
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Formato de entrada
        if let date = dateFormatter.date(from: dateString) {
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "dd-MMM-yyyy" // Formato de salida (día-mes-año)
            customFormatter.locale = Locale(identifier: "es_ES") // Configurar el idioma a español
            return customFormatter.string(from: date)
        }
        return ""
    }
    
    func getDateFormatter(fecha: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: fecha)
    }
    
    
}
