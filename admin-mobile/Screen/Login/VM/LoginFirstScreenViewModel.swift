//
//  File.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import Foundation


class LoginFirstScreenViewModel {
       
    
    private var username = ""
    private var password = ""
    
    let queue = DispatchQueue(label: "FetchUserDetail")
    
    
//    var userCurrentInfo:GetUserInfor?
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func setUsername(username: String) {
        self.username = username
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func fetchUserDetail() {
        APIManager.shared.request(modelType: ResponseMyProfile.self, type: UserEndPoint.profile, params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let profile):
                if let encodedUserDetail = try? JSONEncoder().encode(profile.data?.userProfile) {
                    Contanst.userdefault.set(encodedUserDetail, forKey: "userInfoDetail")
                }
                self.eventHandler?(.dataLoaded)

            case .failure(let error):

                if case DataError.invalidResponse400(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }

//                self.eventHandler?(.error(error.localizedDescription))

            }
        })
    }
    
    func handelLogin() {
        self.eventHandler?(.loading)
        if(username.isEmpty || password.isEmpty || !username.isValidEmail()) {
            self.eventHandler?(.stopLoading)
            self.eventHandler?(.invalid)
        } else {

            let params = InfoLogin(email: username, password: password)
            let parameter = try? APIManager.shared.encodeBody(value: params)
            
            APIManager.shared.request(modelType: ReponseLogin.self, type: UserEndPoint.login(infoLogin: params), params: parameter, completion: {
                result in
                switch result {
                case .success(let info): print(info)
                        TokenService.tokenInstance.saveToken(token: info.data?.accessToken ?? "", refreshToken: info.data?.refreshToken ?? "")
                        if let encodedUser = try? JSONEncoder().encode(info.data?.getUserInfor) {
                            Contanst.userdefault.set(encodedUser, forKey: "userInfo")
                        }
    //                    self.fetchUserDetail()

                        self.queue.async {
                            //Lay du lieu tu server
                            self.fetchUserDetail()
                        }
                    
                    case .failure(let error):
                        if case DataError.invalidResponse400(let reason) = error {
                            self.eventHandler?(.error(reason))
                        }
                        else {
                            self.eventHandler?(.error(error.localizedDescription))
                        }
//                    self.eventHandler?(.error(error.localizedDescription))
                    }
            })
        }
    }
    
}



extension LoginFirstScreenViewModel {

    enum Event {
        case loading
        case invalid
        case stopLoading
        case dataLoaded
//        case error(Error?)
        case error(String?)

//        case newProductAdded(product: AddProduct)
    }

}
