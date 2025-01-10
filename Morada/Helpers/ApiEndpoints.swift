//
//  ApiEndpoints.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation

class ApiEndpoints{
    
    static let baseUrl = "https://zxnmqcu8mj.us-east-1.awsapprunner.com"
    static let proUrl = "https://www.jarboss.com"
    static let authUrl = "https://tpmmhy4d2s.us-east-1.awsapprunner.com"
    static let generalUrl = "https://qzv5egqxrn.us-east-1.awsapprunner.com"
    
    static var loginUrl: String{
        return authUrl+"/management/auth"
    }
    
    static func getDataUse(email: String) -> String{
        return generalUrl+"/management/getUserFire?email="+email
    }
    
    static var emailUrl: String{
        return baseUrl+"/Fraccionamientos/POST/?source1=index&source2=reccontrasena"
    }
    
    static var creaateUserUrl: String {
        return baseUrl+"/Fraccionamientos/POST/?source1=index&source2=setusuario"
    }
    
    static var getResidentsUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=getresidentes"
    }
    
    static var getBinnacleUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=ingresadas"
    }
    
    static var getAgendaUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=buscadorAgendaApp"
    }
    static var searchBinnacleUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=buscadorLetras"
    }
    static var searhcAgendaUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=buscadorLetrasag"
    }
    static var getEventosUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=evento&source2=getevento"
    }
    static var setEventoUrl: String {
        return baseUrl+"/Fraccionamientos/POST/?source1=evento&source2=setevento"
    }
    static var deleteEventoUrl: String {
        return baseUrl+"/Fraccionamientos/POST/?source1=evento&source2=deleventoid"
    }
    static var getIncidentsUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=incidencia&source2=getincidenciaApp"
    }
    static func getImageUrl(img: String) -> String {
        return baseUrl+"/Fraccionamientos/uploads/"+img
    }
    static var getIncidentsByDateUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=incidencia&source2=getincidencia"
    }
    static func getReservationsUrl(idUser: String) -> String {
        return baseUrl+"/management/getReservation?uuid="+idUser
    }
    static var setReservationUrl: String {
        return baseUrl+"/management/createReservation"
    }
    static var getAvisosUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=aviso&source2=getavisoApp"
    }
    static var setAgendaUrl: String {
        return baseUrl+"/Fraccionamientos/POST/?source1=visita&source2=setAgenda"
    }
    static var getImgUrl: String {
        return proUrl+"/QR_plugin/"
    }
    static var getQrUrl: String {
        return proUrl+"/QR_plugin/temp/centercomm/"
    }
    static var getVisitasUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=get_visitasApp"
    }
    static var getVisitasAgendaUrl: String {
        return baseUrl+"/Fraccionamientos/GET/?source1=visitas&source2=getAgendaApp"
    }
}
