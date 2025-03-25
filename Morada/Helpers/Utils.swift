//
//  Utils.swift
//  Morada
//
//  Created by MacBook Air on 04/02/25.
//

import Foundation
import SwiftUI
import AVFoundation

class Utils {
    /// Formatea una fecha de `String` a `dd-MMM-yyyy`
    static func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Formato de entrada
        if let date = dateFormatter.date(from: dateString) {
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "dd-MMM-yyyy" // Formato de salida (día-mes-año)
            customFormatter.locale = Locale(identifier: "es_MX") // Configurar el idioma a español
            return customFormatter.string(from: date)
        }
        return ""
    }

    /// Genera una imagen azul de 100x100 y la convierte en base64
    static func generateTemporaryImage() -> String? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let imageData = image?.jpegData(compressionQuality: 0.8) {
            return imageData.base64EncodedString()
        }
        return nil
    }
    
    // Obtiene la fecha y hora actual
    static func getDateHour() -> String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    static func isValidEmail(email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true) // Ya tiene permisos
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted) // Se solicita permiso al usuario
            }
        case .denied, .restricted:
            completion(false) // El usuario denegó el permiso
        @unknown default:
            completion(false)
        }
    }
}
