//
//  AccessViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 06/11/24.
//

import Foundation
import UIKit
import SwiftUI

class AccessViewModel: ObservableObject {
    // visiter
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var typeVisit = ""
    
    // resident data
    @Published var residentsList: [ResidentResponse] = []
    @Published var selectedResident: ResidentResponse? = nil
    @Published var address = ""
    @Published var company = ""
    
    @Published var idSucursal: String?
    @Published var names: [String] = []
    @Published var tiposVisita: [String] = ["Familiar/Amigo","Paquetería","Empleado"]
    
    @Published var selectedName: String? = nil
    @Published var selectedOption: String? = nil
    
    @Published var messageError: String = ""
    
    @Published var date = Date()
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var eventTime = Date()
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showMessage = false
    @Published var successMessage = ""
    
    @Published var disableButton = false
    
    // DETAILS VISIT VARIABLES
    @Published var title = ""
    @Published var searchText = ""
    @Published var isSearching = false // Estado para el indicador de progreso
    @Published var registros: [GetVistasResponse] = [] // Resultados filtrados
    @Published var showModal = false
    @Published var selectedVisita: GetVistasResponse? = nil
    @Published var selectedButton: Int = 1
    
    @Published var binnacleList: [CheckOutResponse] = [] // Resultados filtrados
    @Published var selectedBinnacle: CheckOutResponse? = nil
    
    var mtipo: Int?
    
    private let apiService = ApiService()
    
    let uuidAdmin = UserSession.shared.userData?.uuidSuperAdmin
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
    
    init(){
        let type = UserSession.shared.userResponse?.tipo
        if let ttipo = type {
            mtipo = ttipo
            
        } else {
            print("El tipo es nil")
        }
        
        Task{
            await getResidents()
        }
    }
    
    @MainActor
    func getResidents() async{
        do{
            
            
            let response: [ResidentResponse] = try await apiService.get(urlString: ApiEndpoints.getResidentsUrl(idAssigned: self.idAssignedValue))
            
            if !response.isEmpty{
                self.residentsList.removeAll()
                self.residentsList = response
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
    func creaeNewEvent() async{
        do {
            let ahora = Date()
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: ahora) // Esto elimina la hora y solo deja la fecha

            // Usa `calendar.startOfDay` para también asegurar que `date` se compara solo como fecha, sin la hora
            let selectedDate = calendar.startOfDay(for: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let soloFecha = dateFormatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let startEvent = timeFormatter.string(from: eventTime)

            if name.isEmpty || email.isEmpty || phone.isEmpty || typeVisit.isEmpty{
                self.errorMessage = "Todos los campos son obligatorios."
                self.showError = true
                return
            }
            if !Utils.isValidEmail(email: email){
                self.errorMessage = "Correo inválido."
                self.showError = true
                return
            }
            if !isValidPhoneNumber(phone) {
                self.errorMessage = "Número de teléfono inválido"
                self.showError = true
                return
            }
            guard selectedDate >= today else {
                self.errorMessage = "La fecha de visita debe ser hoy o en el futuro."
                self.showError = true
                return
            }
            
//            if selectedResident == nil{
//                self.errorMessage = "Todos los campos son obligatorios."
//                self.showError = true
//                return
//            }
//           
            self.showError = false
           
            
            if let resident = self.residentsList.first(where: { $0.uuid == self.uuid }) {
                self.selectedResident = resident
            }
           
            
            let body = VisitRequest(
                name: self.name,
                email: self.email,
                visit: self.selectedResident?.username ?? "",
                address: self.selectedResident?.address ?? "",
                phone: self.phone,
                typeVisit: self.typeVisit,
                dateI: "\(soloFecha) \(startEvent)",
                uuidSuperAdmin: self.uuidAdmin!,
                uuid: self.uuid!,
                idAssigned: self.idAssignedValue
            )

            
            let response: RegisterVisitResponse = try await apiService.postJson(urlString: ApiEndpoints.setAgendaUrl, body: body)
          
            if response.message == "Agenda of visits created successfully" {
                self.isLoading = false
                self.showError = false
                //self.disableButton = true
                self.successMessage = "Evento reservado"
                self.showMessage = true
                
                await getImg(id: response.fileName.first ?? "",uuid: self.uuid!)
                clearFields()
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
    
    func clearFields(){
        self.name = ""
        self.email = ""
        self.phone = ""
        self.typeVisit = ""
        self.selectedResident = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showError = false
            self.showMessage = false
        }
    }
    
    @MainActor
    func getImg(id:String,uuid: String) async{
        do{
            
            
            let urlImg = ApiEndpoints.getQrUrl(id: id, uuid: uuid)
            let dataImg = try await apiService.downloadImage(from: urlImg)
            
            
            // Paso 4: Abre el UIActivityViewController para compartir
            let activityVC = UIActivityViewController(activityItems: [dataImg], applicationActivities: nil)
            
            // Opcional: Si quieres solo WhatsApp, puedes filtrar las actividades de esta forma
            //activityVC.excludedActivityTypes = [.postToFacebook, .postToTwitter, .mail, .message]
            
            DispatchQueue.main.async {
                // Presenta el UIActivityViewController en el hilo principal
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    keyWindow.rootViewController?.present(activityVC, animated: true, completion: nil)
                }
            }
            
            
        }catch let error as ApiError {
            
          print("ERROR: \(error)")
            
            
        } catch {
            
            print("ERROR: \(error)")
        }
    }
    
    @MainActor
    func resetFields(){
        //self.disableButton = false
        self.showError = false
        self.errorMessage = ""
        self.showMessage = false
        self.successMessage = ""
        self.name = ""
        self.phone = ""
        self.company = ""
        self.date = Date()
        self.startTime = Date()
        self.endTime = Date()
        self.eventTime = Date()
        
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    /// DETAILS VISIT FUCNS
    
    @MainActor
    func changeTitle(title: String) {
        self.title = title
        
    }
    
    @MainActor
    func changeColor(active: Int) {
        
        self.selectedButton = active
        
    }
    
    @MainActor
    func fetchBinnacleRegisters() async{
        do {
            self.isSearching = true
            let response: [CheckOutResponse] = try await apiService.get(urlString: ApiEndpoints.getBinnacleUrl(uuid: self.uuid!) )
            
            if !response.isEmpty{
                
                let registrosPrcesados = response.map{ registro in
                    return CheckOutResponse(
                        id: registro.id,
                        name: registro.name,
                        issue: registro.issue,
                        visit: registro.visit,
                        address: registro.address,
                        phone: registro.phone,
                        typeVisit: registro.typeVisit,
                        evidence: registro.evidence,
                        status: registro.status,
                        uuid: registro.uuid,
                        uuidSuperAdmin: registro.uuidSuperAdmin,
                        idAssigned: registro.idAssigned,
                        v: registro.v,
                        assigned: registro.assigned,
                        lastName: registro.lastName,
                        dateI: registro.dateI,
                        dateF: registro.dateF,
                        dateFormated: Utils.formatDate(registro.dateI)
                    )
                    
                }
                
                
                self.binnacleList.removeAll()
                self.binnacleList = registrosPrcesados
            print("Registros ejecutado")
                
            }else{
                print("No hay registros en la bitacora")
            }
            self.isSearching = false
            
        } catch let error as ApiError {
            // Manejar errores específicos de la API
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Error: \(error)"
                self.showError = true
                self.isSearching = false
                print("ERROR: \(error)")
            }
        } catch {
            // Manejar errores genéricos
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Ocurrió un error inesperado"
                self.showError = true
                self.isSearching = false
                print("ERROR: \(error)")
            }
        }
    }
    
    @MainActor
    func fetchAgendaRegisters() async{
        do {
            self.isSearching = true
            let response: [GetVistasResponse] = try await apiService.get(urlString: ApiEndpoints.getVisitasUrl(uuid: self.uuid ?? ""))
            
            if !response.isEmpty{
                
                let registrosPrcesados = response.map{ registro in
                    return GetVistasResponse(
                        id: registro.id,
                        name: registro.name,
                        visit: registro.visit,
                        email: registro.email,
                        address: registro.address,
                        phone: registro.phone,
                        typeVisit: registro.typeVisit,
                        evidence: registro.evidence,
                        status: registro.status,
                        uuid: registro.uuid,
                        uuidSuperAdmin: registro.uuidSuperAdmin,
                        idAssigned: registro.idAssigned,
                        v: registro.v,
                        assigned: registro.assigned,
                        nameUser: registro.nameUser,
                        lastName:registro.lastName,
                        dateI: registro.dateI,
                        dateF: registro.dateF,
                        dateFormated: Utils.formatDate(registro.dateI ?? "")
                    )
                    
                    
                }
                
                
                self.registros.removeAll()
                self.registros = registrosPrcesados
                
                
            }
            self.isSearching = false
        } catch let error as ApiError {
            // Manejar errores específicos de la API
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Error: \(error)"
                self.showError = true
                self.isSearching = false
                print("ERROR: \(error)")
            }
        } catch {
            // Manejar errores genéricos
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Ocurrió un error inesperado"
                self.showError = true
                self.isSearching = false
                print("ERROR: \(error)")
            }
        }
    }
    
    func getIconName(for status: String) -> String {
        switch status {
        case "0":
            return "sync" // sin llegar
        case "1":
            return "entrada1" // entrada
        case "2":
            return "salida1" // salida
        default:
            return "info.circle.fill" // Ícono por defecto
        }
    }
    
    @MainActor
    func shareQr() async{
        
    }
    
    private func formatTimeOnly(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        let possibleFormats = ["HH:mm", "HH:mm:ss"] // Formatos posibles de entrada

        for format in possibleFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: timeString) {
                dateFormatter.dateFormat = "h:mm a" // Formato de salida (12 horas con AM/PM)
                return dateFormatter.string(from: date)
            }
        }
        return ""
    }

    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        let possibleFormats = ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"] // Formatos posibles de entrada

        for format in possibleFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                let customFormatter = DateFormatter()
                customFormatter.dateFormat = "dd-MMM-yyyy" // Formato de salida (día-mes-año)
                customFormatter.locale = Locale(identifier: "es_ES") // Configurar el idioma a español
                return customFormatter.string(from: date)
            }
        }
        return ""
    }
    
}
