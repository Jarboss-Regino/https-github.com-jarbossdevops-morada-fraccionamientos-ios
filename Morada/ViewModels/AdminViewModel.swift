//
//  AdminViewModel.swift
//  Morada
//
//  Created by MacBook Air on 28/01/25.
//

import Foundation

class AdminViewModel: ObservableObject{
    
    // add event variables
    @Published var numPeople: Int = 1
    @Published var date = Date()
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var titleEvent = ""
    @Published var descriptionEvent = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var showMessage = false
    @Published var successMessage = ""
    @Published var disableButton = false
    
    @Published var showAdmisList = false
    
    
    @Published var admins: [AdminsResponse] = []
    @Published var selectedAdmin: AdminsResponse? = nil
    @Published var selectedNameAdmin = "estado actual"
    
    private let apiService = ApiService()
    
    let idUser = UserSession.shared.userData?.uuid
    let username = UserSession.shared.userData?.username
    let uuidAdmin = UserSession().userData?.uuidSuperAdmin
    
    
    init(){
        Task{
            await getAdmins()
        }
    }
    
    @MainActor
    func creaeNewEvent() async{
        do {
            let ahora = Date()
            print(ahora)
            
            if admins.isEmpty{
                self.errorMessage = "Debe de llenar todos los campos"
                self.showError = true
                return
            }
            self.showError = false
            if self.titleEvent.isEmpty{
                self.errorMessage = "Debe de llenar todos los campos"
                self.showError = true
                return
            }
            self.showError = false
            
            if self.descriptionEvent.isEmpty{
                self.errorMessage = "Debe de llenar todos los campos"
                self.showError = true
                return
            }
            self.showError = false
            
            if numPeople <= 0{
                self.errorMessage = "El número de personas debe ser mayor a 0"
                self.showError = true
                return
            }
            
            self.showError = false
            print("FECHA FECHA FECHA")
            
            let calendar = Calendar.current
            let truncatedDate = calendar.startOfDay(for: date)
            let truncatedAhora = calendar.startOfDay(for: ahora)
           
            guard truncatedDate >= truncatedAhora else {
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
            
            self.errorMessage = ""
            self.showError = false
            self.isLoading = true
           
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let soloFecha = dateFormatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let start = timeFormatter.string(from: startTime)
            let end = timeFormatter.string(from: endTime)
            
            let totalPeople = String(numPeople)
            
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
            print("fecha enviada")
            print("\(soloFecha) \(start)")
            print("\(soloFecha) \(end)")
            let body = NewEventRequest(
                user: selectedAdmin?.username ?? self.username!,
                dateI: "\(soloFecha) \(start)",
                dateF: "\(soloFecha) \(end)",
                persons: totalPeople,
                tittle: self.titleEvent,
                description: self.descriptionEvent,
                uuidSuperAdmin: self.uuidAdmin!,
                uuid: selectedAdmin?.uuid ?? self.idUser!,
                idAssigned: idAssignedValue
            )
            
            let response: NewEventResponse = try await apiService.postJson(urlString: ApiEndpoints.setEventoUrl, body: body)
            
            
            if response.message == "Event created successfully" {
                self.isLoading = false
                self.showError = false
                self.disableButton = true
                self.successMessage = "Evento reservado"
                self.showMessage = true
            }else{
                self.isLoading = false
                self.errorMessage = "Ocurrio un error al registrar el evento"
                self.showError = true
            }
            
            
            
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
    func getAdmins() async{
        do {
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
            let response: [AdminsResponse] = try await apiService.get(urlString: ApiEndpoints.getAdminsUrls(idAssigned: idAssignedValue))
            
            if !response.isEmpty{
//                let adminsPrcesados = response.map{ admin in
//                    return AdminsResponse(
//                        id: admin.id,
//                        name: admin.name,
//                        lastName: admin.lastName,
//                        identityNumber: admin.identityNumber,
//                        access: admin.access,
//                        email: admin.email,
//                        idAssigned: admin.idAssigned,
//                        assigned: admin.assigned,
//                        uuidSuperAdmin: admin.uuidSuperAdmin,
//                        uuid: admin.uuid,
//                        username: admin.username,
//                        v: admin.v
//                    )
//                }
                DispatchQueue.main.async {
                    self.admins.removeAll()
                    self.admins = response
                    self.showAdmisList = true
                    self.selectedNameAdmin = self.admins.first?.email ?? "no data"
                    print("GET ADMINS EJECUTADO")
                }
                
            }else{
                print("no hay admins")
                self.showAdmisList = false
            }
            
        } catch let error as ApiError {
            
            print("ERROR: \(error)")
            self.showAdmisList = false
            
        } catch {
            
            print("ERROR: \(error)")
            self.showAdmisList = false
            
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
        self.titleEvent = ""
        self.descriptionEvent = ""
        self.date = Date()
        self.startTime = Date()
        self.endTime = Date()
        
    }
}
