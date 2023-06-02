//
//  ForgetPasswordViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/04/2023.
//

import Foundation

class ForgetPasswordViewModel {
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func sendOTPForget(from param: SendOTPDto?) {
        let parameter = try? APIManager.shared.encodeBody(value: param)
        
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.sendOTP, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            
            switch result {
            case .success(let data):
                Contanst.userdefault.set(param?.email, forKey: "email")
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                if case DataError.invalidResponse(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }
                
            }
        })
    }
    
    func forgetPassword(from param: ForgetpasswordDto?) {
        let parameter = try? APIManager.shared.encodeBody(value: param)
        
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.forgetPassword, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                if case DataError.invalidResponse(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }
                
            }
        })
    }
    
    
}


extension ForgetPasswordViewModel {

    enum Event {
        case loading
        case invalid
        case stopLoading
        case dataLoaded
        case error(String?)
    }
}
