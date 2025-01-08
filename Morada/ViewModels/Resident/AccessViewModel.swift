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
    @Published var name = ""
    @Published var address = ""
    @Published var phone = ""
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
    @Published var registros: [DetailVisitas] = [] // Resultados filtrados
    @Published var showModal = false
    @Published var selectedVisita: DetailVisitas? = nil
    @Published var selectedButton: Int = 1
    
    var mtipo: Int?
    
    private let apiService = ApiService()
    
    init(){
        let type = UserSession.shared.userResponse?.tipo
        if let ttipo = type {
            mtipo = ttipo
            
        } else {
            print("El tipo es nil")
        }
    }
    
    @MainActor
    func creaeNewEvent() async{
        do {
            let ahora = Date()
            print(ahora)
            
            if selectedOption == nil{
                self.errorMessage = "Todos los campos deben ir llenos."
                self.showError = true
                return
            }
            
            if selectedOption == "Familiar/Amigo"{
                if name.isEmpty || phone.isEmpty{
                    self.errorMessage = "Todos los campos deben ir llenos."
                    self.showError = true
                    return
                }
                if !isValidPhoneNumber(phone) {
                    self.errorMessage = "Número de teléfono inválido"
                    self.showError = true
                    return
                }
                guard date >= ahora else {
                    self.errorMessage = "La fecha del evento debe ser en el futuro."
                    self.showError = true
                    return
                }
                guard eventTime >= ahora else {
                    self.errorMessage = "La hora del evento debe ser mayor a la hora actual."
                    self.showError = true
                    return
                }
            }
            
            if selectedOption == "Paquetería"{
                if company.isEmpty || phone.isEmpty{
                    self.errorMessage = "Todos los campos deben ir llenos."
                    self.showError = true
                    return
                }
                if !isValidPhoneNumber(phone) {
                    self.errorMessage = "Número de teléfono inválido"
                    self.showError = true
                    return
                }
                guard date >= ahora else {
                    self.errorMessage = "La fecha del evento debe ser en el futuro."
                    self.showError = true
                    return
                }
            }
                
                
            
            
            if selectedOption == "Empleado"{
                if name.isEmpty || phone.isEmpty{
                    self.errorMessage = "Todos los campos deben ir llenos."
                    self.showError = true
                    return
                }
                if !isValidPhoneNumber(phone) {
                    self.errorMessage = "Número de teléfono inválido"
                    self.showError = true
                    return
                }
                guard startTime >= ahora else {
                    self.errorMessage = "La fecha de inicio debe ser en el futuro."
                    self.showError = true
                    return
                }
                guard endTime > ahora else {
                    self.errorMessage = "La fecha fin no debe ser mayor a la fecha inicio"
                    self.showError = true
                    return
                }
            }
   
            self.showError = false
            
            var idUser: String = "0"
//            if mtipo != 0{
                idUser = (UserSession.shared.userResponse?.id)!
//            }
//            
            let idFraccionamiento = (UserSession.shared.userResponse?.idCliente)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let soloFecha = dateFormatter.string(from: date)
            let fechaInicio = dateFormatter.string(from: startTime)
            let fechaFin = dateFormatter.string(from: endTime)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let startEvent = timeFormatter.string(from: eventTime)
           
            
            let body = VisitRequest(source1: self.selectedOption!, source2: idUser, source3: self.name, source4: "", source5: "", source6: self.phone, source7: soloFecha, source8: startEvent, source9: idFraccionamiento, source10: fechaInicio, source11: fechaFin)

            
            let response: RegisterVisitResponse = try await apiService.post(urlString: ApiEndpoints.setAgendaUrl, body: body)
          
            if response.status == "ok" {
                self.isLoading = false
                self.showError = false
                self.disableButton = true
                self.successMessage = "Evento reservado"
                self.showMessage = true
                await getImg(id: response.id)
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
    func getImg(id:String) async{
        do{
            let body = QrRequest(data: id, source2: "centercomm", source3: "centercomm_"+id, source4: "")
            
            let response: QrResponse = try await apiService.post(urlString: ApiEndpoints.getImgUrl, body: body)
            
            // Paso 2: Construye la URL completa con el nombre de la imagen
            let imageUrlString = "\(ApiEndpoints.getQrUrl)\(response.img)"
            guard let imageUrl = URL(string: imageUrlString) else { return }
            // Paso 3: Descarga la imagen
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            guard let image = UIImage(data: data) else { return }
            
            // Paso 4: Abre el UIActivityViewController para compartir
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
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
            var idFraccionamiento: String = "0"
            if mtipo != 1{
                idFraccionamiento = (UserSession.shared.userResponse?.idCliente)!
            }
//
            let idUser = (UserSession.shared.userResponse?.id)!
            
            let body = GetVisitRequest(source1: "00", source2: "", source3: idFraccionamiento, source4: idUser)
            
            let response: GetVistasResponse = try await apiService.post(urlString: ApiEndpoints.getVisitasUrl, body: body)
            
            if !response.registros.isEmpty{
                
                let registrosPrcesados = response.registros.map{ registro in
                    return DetailVisitas(
                        id: registro.id,
                        estatus: registro.estatus,
                        nombre: registro.nombre,
                        domicilio: registro.domicilio,
                        numero: registro.numero,
                        visita_a: registro.visita_a,
                        tipovis: registro.tipovis,                        
                        fecha: formatDate(registro.fecha),
                        hora: formatTimeOnly(registro.hora),
                        entrada: formatTimeOnly(registro.entrada),
                        salida: formatTimeOnly(registro.salida),
                        evidencia: registro.evidencia,
                        tabla: registro.tabla
                    )
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.registros.removeAll()
                    self.registros = registrosPrcesados
                    print(self.registros)
                }
                
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
            var idFraccionamiento: String = "0"
            if mtipo != 1{
                idFraccionamiento = (UserSession.shared.userResponse?.idCliente)!
            }
            //
            let idUser = (UserSession.shared.userResponse?.id)!
            
            
            let body = GetVisitAgendaRequest(source1: "00", source2: idFraccionamiento, source3: idUser)
            
            let response: GetVistasResponse = try await apiService.post(urlString: ApiEndpoints.getVisitasAgendaUrl, body: body)
            
            if response.status == "ok"{
                
                let registrosPrcesados = response.registros.map{ registro in
                    return DetailVisitas(
                        id: registro.id,
                        estatus: registro.estatus,
                        residente: registro.residente,
                        nombre: registro.nombre,
                        domicilio: registro.domicilio,
                        numero: registro.numero,
                        tipovis: registro.tipovis,                        
                        fecha: formatDate(registro.fecha),
                        hora: formatTimeOnly(registro.hora),
                        entrada: formatTimeOnly(registro.entrada),
                        salida: formatTimeOnly(registro.salida), 
                        tabla: registro.tabla
                    )
                    
                }
                
                DispatchQueue.main.async {
                    self.registros.removeAll()
                    self.registros = registrosPrcesados
                    print(self.registros)
                }
               
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
