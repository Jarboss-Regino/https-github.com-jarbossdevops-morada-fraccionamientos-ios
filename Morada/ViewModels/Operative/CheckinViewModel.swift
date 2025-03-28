//
//  CheckinViewModel.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 30/09/24.
//

import Foundation
import UIKit

class CheckinViewModel: ObservableObject {
    
    
    @Published var name = ""
    @Published var issue = ""
    @Published var address = ""
    @Published var number = ""
//    {
//        didSet {
//            // Filtra solo números y limita a 10 caracteres
//            number = String(number.prefix(10)).filter { $0.isNumber }
//        }
//    }
    @Published var email = ""
    @Published var arrivalDate = ""
    
    @Published var idSucursal: String?
    @Published var names: [ResidentResponse] = []
    @Published var tiposVisita: [String] = ["Familiar/Amigo","Paquetería","Empleado"]
    
    @Published var selectedName: ResidentResponse? = nil
    @Published var selectedOption: String? = nil
    
    @Published var showError: Bool = false
    @Published var messageError: String = ""
    
    @Published var showSuccessMsg = false
    @Published var msgSuccess = ""
    
    @Published var isOn = false
    
    @Published var selectedImageINE: UIImage?
    @Published var selectedImageLicence: UIImage?
    @Published var base64Image: String?
    
    private var apiService = ApiService()
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

        Task{
            await getResidents()
        }

    }
    
    @MainActor
    func getResidents() async{
        do{
            
            
            let response: [ResidentResponse] = try await apiService.get(urlString: ApiEndpoints.getResidentsUrl(idAssigned: self.idAssignedValue))
            
            if !response.isEmpty{
                self.names.removeAll()
                self.names = response
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
    func doRegister() async{
        do{
            if isOn {
                if self.name.isEmpty || self.address.isEmpty || self.number.isEmpty || self.email.isEmpty || self.arrivalDate.isEmpty{
                    self.messageError = "Por favor, llene todos los campos"
                    self.showError = true
                    return
                }
                if self.selectedImageINE == nil || self.selectedImageLicence == nil{
                    self.messageError = "Las fotografrías son obligatorias"
                    self.showError = true
                    return
                }
            }
            
            if self.name.isEmpty || self.address.isEmpty || self.number.isEmpty || self.selectedName == nil || self.selectedOption == nil{
                
                self.messageError = "Por favor, llene todos los campos"
                self.showError = true
                return
                
            }
            if self.selectedImageINE == nil || self.selectedImageLicence == nil{
                self.messageError = "Las fotografrías son obligatorias"
                self.showError = true
                return
            }
            
            self.showError = false
            
            let img = Utils.convertToBase64(image: self.selectedImageINE!)
            let img2 = Utils.convertToBase64(image: self.selectedImageLicence!)
            
            let body = SetVisitRequest(
                name: self.name,
                issue: self.issue,
                visit: self.selectedName?.username ?? "",
                address: self.address,
                phone: self.number,
                typeVisit: self.selectedOption!,
                dateI: Utils.getDateHour(),
                uuidSuperAdmin: self.uuidAdmin!,
                uuid: self.uuid!,
                idAssigned: self.idAssignedValue,
                evidence: "\(String(describing: img)),\(String(describing: img2))"
            )
            
            let response: SetVisitResponse = try await apiService.postJson(urlString: ApiEndpoints.setVisit, body: body)
            
            if response.message == "Record of visits created successfully" {
                
                self.showError = false
                self.msgSuccess = "Registro creado correctamente"
                self.showSuccessMsg = true
                cleanFields()
            }else{
                print("Ocurrio un error")
                self.showError = true
                self.messageError = "Ocurrio un error"
                self.showSuccessMsg = false
            }
            
        }catch let error as ApiError {
            
            
            print("Error: \(error)")
                
            
        } catch {
            
            print("Error desconocido")
            
        }
        
        
    }
    
    func searchVisitData(idValue: String) async {
        do{
            if idValue.isEmpty {
                return
            }
            
            let response: [GetVistasResponse] = try await apiService.get(urlString: ApiEndpoints.getVisitasUrl(uuid: self.uuid ?? ""))
            
            if !response.isEmpty{
                let filteredResponse = response.filter{ $0.id == idValue }
                if let matchingItem = filteredResponse.first {
                    print("Elemento encontrado: \(matchingItem)")
                    self.name = matchingItem.name
                    self.number = matchingItem.phone
                    self.email = matchingItem.email
                    self.arrivalDate = matchingItem.dateFormated ?? ""
                    self.address = matchingItem.address
                } else {
                    print("No se encontró ningún elemento con ese ID")
                }
            }
            
        }catch let error as ApiError {
            
            
            print("Error: \(error)")
                
            
        } catch {
            
            print("Error desconocido")
            
        }
    }
    
    func cleanFields(){
        self.name = ""
        self.issue = ""
        self.selectedName = nil
        self.address = ""
        self.number = ""
        self.selectedOption = ""
        self.selectedImageINE = nil
        self.selectedImageLicence = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showSuccessMsg = false
            
        }
    }
    
    @MainActor
    func resetMessageError(){
        DispatchQueue.main.async {
            self.messageError = ""
            self.showError = false
        }
        
    }
}

