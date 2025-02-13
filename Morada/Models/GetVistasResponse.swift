//
//  GetVistasResponse.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 12/11/24.
//

import Foundation

struct GetVistasResponse: Codable, Identifiable{
  let id: String
  let name: String
  let visit: String
  let email: String
  let address: String
  let phone: String
  let typeVisit: String
  let evidence: String
  let status: String
  let uuid: String
  let uuidSuperAdmin: String
  let idAssigned: AssignedID
    let v: Int
  let dateI: String?
  let dateF: String?
  
  enum CodingKeys: String, CodingKey {
      case id = "_id"
      case name, visit, email, address, phone, typeVisit, evidence, status, uuid, uuidSuperAdmin, idAssigned, v = "__v", dateI, dateF
  }
}
    
