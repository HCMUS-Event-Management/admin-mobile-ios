//
//  Extensions.swift
//  mobile
//
//  Created by NguyenSon_MP on 04/03/2023.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyRSA
import CoreImage.CIFilterBuiltins
public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

extension UIViewController {
    func loader() -> UIAlertController {
        let alter = UIAlertController(title: nil, message: "Vui lòng chờ", preferredStyle: .alert)
        let indicator  = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        alter.view.addSubview(indicator)
        present(alter, animated: true, completion: nil)
        return alter
    }
    
    
    
    func stoppedLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }
    
    
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPhone() -> Bool {
            let inputRegEx = "^((\\+)|(00))[0-9]{6,14}$"
            let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
            return inputpred.evaluate(with:self)
        }
}

extension UIViewController {

    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    func changeScreen<T: UIViewController>(
        modelType: T.Type,
        id: String
    ) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: id) as? T else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
           if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
               return UIImage(cgImage: qrCodeCGImage)
           }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
    
    func decodeRSA(from string: String) -> String? {
        do {

            let privateKey = try PrivateKey(pemEncoded: ProcessInfo.processInfo.environment["RSA_PRIVATE_KEY"]!)
            
            let encrypted = try EncryptedMessage(base64Encoded: string)
            let clear = try encrypted.decrypted(with: privateKey, padding: .PKCS1)

            // Then you can use:
            let data = clear.data
            let base64String = clear.base64String
            let result = try clear.string(encoding: .utf8)
            return result
        } catch {
            print(error)
        }
        return "Lỗi RSA"
        
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}


extension DateFormatter {
    func iso8601String(from date: Date) -> String {
        dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return string(from: date)
    }
}
