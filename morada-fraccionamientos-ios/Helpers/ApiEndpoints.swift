//
//  ApiEndpoints.swift
//  Morada
//
//  Created by MacBook Air on 17/09/24.
//

import Foundation

class ApiEndpoints{
    
    static let baseUrl = "https://www.jarbossdev.com"
    
    static var loginUrl: String{
        return baseUrl+"/Fraccionamientos/GET/?source1=index&source2=getlogin"
    }
    
    static var emailUrl: String{
        return baseUrl+"/Fraccionamientos/POST/?source1=index&source2=reccontrasena"
    }
    
    static var creaateUserUrl: String {
        return baseUrl+"/Fraccionamientos/POST/?source1=index&source2=setusuario"
    }
}
