//
//  CheckinViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 30/09/24.
//

import Foundation

class CheckinViewModel: ObservableObject {
    
    
    @Published var name = ""
    @Published var address = ""
    @Published var number = ""
    @Published var email = ""
    @Published var arrivalDate = ""
    
    @Published var idSucursal: String?
    @Published var names: [String] = []
    @Published var tiposVisita: [String] = ["Familiar/Amigo","Paquetería","Empleado"]
    
    @Published var selectedName: String? = nil
    @Published var selectedOption: String? = nil
    
    @Published var showError: Bool = false
    @Published var messageError: String = ""
    
    @Published var isOn = false
    
    private var apiService = ApiService()
    
    init(){
        self.idSucursal = UserSession.shared.userResponse?.idCliente
        
        if let id = idSucursal{
            Task{
                await getResidents(id:id)
            }
            
        }else{
            print("Error al traer el idSucursal")
        }
    }
    
    @MainActor
    func getResidents(id: String) async{
        do{
            let body = ResidentRequest(source1: id)
            
            let response: [ResidentResponse] = try await apiService.post(urlString: ApiEndpoints.getResidentsUrl, body: body)
            
            DispatchQueue.main.async {
                self.names = response.map{$0.nombre}
            }
            
        }catch let error as ApiError {
            DispatchQueue.main.async {
                
                print("Error: \(error)")
                
            }
        } catch {
            DispatchQueue.main.async {
                print("Error desconocido")
            }
        }
    }
    
    @MainActor
    func doRegister(){
        
        if isOn {
            if self.name.isEmpty || self.address.isEmpty || self.number.isEmpty || self.email.isEmpty || self.arrivalDate.isEmpty{
                self.messageError = "La foto de identificación es obligatoria"
                self.showError = true
                return
            }
        }
        
        if self.name.isEmpty || self.address.isEmpty || self.number.isEmpty || self.selectedName == nil || self.selectedOption == nil{
            
            self.messageError = "Por favor, llene todos los campos"
            self.showError = true
            return
            
        }
        
        self.showError = false
        print("name: \(self.name)")
        print("name: \(self.address)")
        print("name: \(self.number)")
        print("name: \(self.email)")
        print("name: \(self.arrivalDate)")
        print("name: \(self.selectedName ?? "no selection")")
        print("name: \(self.selectedOption ?? "no selection")")
    }
    
    @MainActor
    func resetMessageError(){
        DispatchQueue.main.async {
            self.messageError = ""
            self.showError = false
        }
        
    }
}

