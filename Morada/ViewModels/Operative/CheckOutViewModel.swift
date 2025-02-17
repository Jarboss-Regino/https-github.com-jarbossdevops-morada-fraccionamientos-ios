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
    @Published var selectedItemBinnacle: CheckOutResponse? = nil
    
    @Published var agendaList: [GetVistasResponse] = []
    @Published var selectedItemAgenda: GetVistasResponse? = nil
    
    private let uuid = UserSession.shared.userData?.uuid
    let uuidAdmin = UserSession.shared.userData?.uuidSuperAdmin
    
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
            
            
            let response: [CheckOutResponse] = try await apiService.get(urlString: ApiEndpoints.getBinnacleUrl(uuid: self.uuid ?? "") )
            
            if !response.isEmpty{
                
                let registrosPrcesados = response
                    .filter{$0.status == "1"}
                    .map{ registro in
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
        do {
            self.isSearching = true
            let response: [GetVistasResponse] = try await apiService.get(urlString: ApiEndpoints.getVisitasUrl(uuid: self.uuid!))
            
            if !response.isEmpty{
                
                let registrosPrcesados = response
                    .filter{$0.status != "0"}
                    .map{ registro in
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
                        lastName: registro.lastName,
                        dateI: registro.dateI,
                        dateF: registro.dateF,
                        dateFormated: Utils.formatDate(registro.dateI ?? "")
                    )
                    
                    
                }
                
                
                self.agendaList.removeAll()
                self.agendaList = registrosPrcesados
            }else{
                print("no hay registros en agenda")
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
    func checkOutBinnacle() async {
        do {
            self.isSearching = true
            
            let body = CheckOutBinncleRequest(id: self.selectedVisita?.id ?? "", status: "2", dateF: Utils.getDateHour())
            
            let response: CheckOutBinnacleResponse = try await apiService.patchJson(urlString: ApiEndpoints.updateStatusRegisterBinncle, body: body)
            
            if !response.agenda.id.isEmpty{
               
                print("Salida marcada desde bitacora")
                
            }else{
                print("Ocurrio un error al marcar la salida")
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
          
            print("ERROR: \(error)")
        }
        
    }
    
    @MainActor
    func checkOutAgenda() async{
        do {
            
            let body = CheckOutAgendaRequest(
                id: self.selectedItemAgenda?.id ?? "",
                status: "2",
                dateF: Utils.getDateHour(),
                dateI: self.selectedItemAgenda?.dateI ?? "",
                uuid: self.selectedItemAgenda?.uuid ?? "",
                idAssigned: self.selectedItemAgenda?.idAssigned.getStringValue() ?? ""
            )
            
            let response: AgendaResponse = try await apiService.patchJson(urlString: ApiEndpoints.updateStatusAgendaUrl, body: body)
            
            if !response.agenda.id.isEmpty{
                print("Salida marcada")
                
            }else{
                print("Ocurrio un error")
            }
            
            
        } catch let error as ApiError {
            // Manejar errores específicos de la API
            
                print("ERROR: \(error)")
            
        } catch {
          
            print("ERROR: \(error)")
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
