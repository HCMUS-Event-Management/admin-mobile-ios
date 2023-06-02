//
//  ChangePasswordViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 08/03/2023.
//

import Foundation
 

class ChangePasswordViewModel {
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func ChangePass(params: ChangePassword) {
        self.eventHandler?(.loading)
        let parameter = try? APIManager.shared.encodeBody(value: params)

        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.changePassword, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                TokenService.tokenInstance.removeTokenAndInfo()
                self.eventHandler?(.logout)
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

extension ChangePasswordViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
//        case error(Error?)
        case error(String?)
        case logout
    }

}
