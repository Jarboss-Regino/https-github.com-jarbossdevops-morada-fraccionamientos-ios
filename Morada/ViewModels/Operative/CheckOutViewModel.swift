//
//  CheckOutViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 03/10/24.
//

import Foundation


class CheckOutViewModel: ObservableObject{
    @Published var title = ""
    @Published var searchText = ""
    @Published var isSearching = false // Estado para el indicador de progreso
    @Published var filteredVisitas: [Registro] = [] // Resultados filtrados
    @Published var showModal = false
    @Published var selectedVisita: Registro? = nil
    @Published var selectedButton: Int = 1
    
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let apiService = ApiService()

    @Published var registros: [Registro] = []
    
    @MainActor
    func startSearch() async{
        isSearching = true
        
        var url = ""
        
        if self.selectedButton == 1{
            url = ApiEndpoints.searchBinnacleUrl
        }else{
            url = ApiEndpoints.searhcAgendaUrl
        }
        
        let body = SearchRequest(source1: "0", source2: "1", source3: self.searchText.trimmingCharacters(in: .whitespaces))

        do {
            let response: [Registro] = try await apiService.post(urlString: url, body: body)
            if response.first?.estatus == 1{
                
                let registrosPrcesados = response.map{ registro in
                    return Registro(id: registro.id, estatus: registro.estatus, nombre: registro.nombre, domicilio: registro.domicilio, numero: registro.numero,visita_a: registro.visita_a, tipovis: registro.tipovis, fecha: registro.fecha, hora: registro.hora, entrada: registro.entrada, salida: registro.salida, tabla: registro.tabla)
                    
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
    func fetchBinnacleRegisters() async{
        do {
            self.isSearching = true
            let body = BinnacleRequest(source1: "0")
            
            let response: CheckOutResponse = try await apiService.post(urlString: ApiEndpoints.getBinnacleUrl, body: body)
            
            if response.status == "ok"{
                
                let registrosPrcesados = response.registros.map{ registro in
                    return Registro(id: registro.id, estatus: registro.estatus, nombre: registro.nombre, domicilio: registro.domicilio, numero: registro.numero,visita_a: registro.visita_a, tipovis: registro.tipovis, fecha: registro.fecha, hora: registro.hora, entrada: registro.entrada, salida: registro.salida, tabla: registro.tabla)
                    
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
            //var id = (UserSession.shared.userResponse?.idCliente)!
            
            let body = AgendaRequest(source1: "1", source2: "")
            
            let response: CheckOutResponse = try await apiService.post(urlString: ApiEndpoints.getAgendaUrl, body: body)
            
            if response.status == "ok"{
                
                let registrosPrcesados = response.registros.map{ registro in
                    return Registro(id: registro.id, estatus: registro.estatus, nombre: registro.nombre, domicilio: registro.domicilio, numero: registro.numero,visita_a: registro.visita_a, tipovis: registro.tipovis,idresidente: registro.idresidente,residente: registro.residente,correo: registro.correo, fecha: registro.fecha, hora: registro.hora, entrada: registro.entrada, salida: registro.salida, tabla: registro.tabla)
                    
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
    func changeTitle(title: String) {
        self.title = title
        
    }
    
    @MainActor
    func changeColor(active: Int) {
        
        self.selectedButton = active
        
    }
}
