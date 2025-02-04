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
    @Published var filteredVisitas: [CheckOutResponse] = [] // Resultados filtrados
    @Published var showModal = false
    @Published var selectedVisita: CheckOutResponse? = nil
    @Published var selectedButton: Int = 1
    
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let apiService = ApiService()

    @Published var registros: [CheckOutResponse] = []
    @Published var selectedItemBinnacle: [CheckOutResponse] = []
    
    private let uuid = UserSession.shared.userData?.uuid
    
    init(){
        Task{
            await fetchBinnacleRegisters()
        }
    }
    
    @MainActor
    func startSearch() async{
        self.isSearching = true
        
        if !registros.isEmpty{
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            let filteredIncidents = registros.filter { item in

                item.name.lowercased().contains(trimmedSearchText) ||
                item.issue.lowercased().contains(trimmedSearchText) ||
                item.visit.lowercased().contains(trimmedSearchText) ||
                item.address.lowercased().contains(trimmedSearchText) ||
                item.typeVisit.lowercased().contains(trimmedSearchText)
            }
            
            if filteredIncidents.isEmpty {
                print("No se encontró ningun registro")
            } else {
                self.registros = filteredIncidents
                print("Incidencias filtradas: \(self.registros)")
            }
        }else{
            print("No se encontró ningun registro")
        }
        self.isSearching = false
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
                        dateI: Utils.formatDate(registro.dateI),
                        dateF: registro.dateF
                    )
                    
                }
                
                
                self.registros.removeAll()
                self.registros = registrosPrcesados
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
//        do {
//            self.isSearching = true
//            //var id = (UserSession.shared.userResponse?.idCliente)!
//            
//            let body = AgendaRequest(source1: "1", source2: "")
//            
//            let response: CheckOutResponse = try await apiService.post(urlString: ApiEndpoints.getAgendaUrl, body: body)
//            
//            if response.status == "ok"{
//                
//                let registrosPrcesados = response.registros.map{ registro in
//                    return Registro(id: registro.id, estatus: registro.estatus, nombre: registro.nombre, domicilio: registro.domicilio, numero: registro.numero,visita_a: registro.visita_a, tipovis: registro.tipovis,idresidente: registro.idresidente,residente: registro.residente,correo: registro.correo, fecha: registro.fecha, hora: registro.hora, entrada: registro.entrada, salida: registro.salida, tabla: registro.tabla)
//                    
//                }
//                
//                DispatchQueue.main.async {
//                    self.registros.removeAll()
//                    self.registros = registrosPrcesados
//                    print(self.registros)
//                }
//               
//            }
//            
//            self.isSearching = false
//        } catch let error as ApiError {
//            // Manejar errores específicos de la API
//            DispatchQueue.main.async {
//                self.isLoading = false
//                self.errorMessage = "Error: \(error)"
//                self.showError = true
//                self.isSearching = false
//                print("ERROR: \(error)")
//            }
//        } catch {
//            // Manejar errores genéricos
//            DispatchQueue.main.async {
//                self.isLoading = false
//                self.errorMessage = "Ocurrió un error inesperado"
//                self.showError = true
//                self.isSearching = false
//                print("ERROR: \(error)")
//            }
//        }
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
