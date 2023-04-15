//
//  ProfileAccountViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 04/03/2023.
//

import Foundation


final class ProfileViewModel {
    var userInfo: GetUserInfor?
    var userInfoDetail: UserProfile?

    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func getUser() {
            if let savedUserData = Contanst.userdefault.object(forKey: "userInfo") as? Foundation.Data {
                let decoder = JSONDecoder()
                if let savedUser = try? decoder.decode(GetUserInfor.self, from: savedUserData) {
                    self.eventHandler?(.stopLoading)
                    userInfo = savedUser
                    self.eventHandler?(.dataLoaded)
                    return
                }
            }
    }
    
    func fetchUserDetail() {
        if((Contanst.userdefault.object(forKey: "userInfoDetail") == nil)) {
            self.eventHandler?(.loading)
            APIManager.shared.request(modelType: ResponseMyProfile.self, type: UserEndPoint.profile, params: nil, completion: {
                result in
                self.eventHandler?(.stopLoading)

                switch result {
                case .success(let profile):
                    self.userInfoDetail = profile.data?.userProfile
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
                    
                }
            })
        } else {
            if let savedUserData = Contanst.userdefault.object(forKey: "userInfoDetail") as? Foundation.Data {
                let decoder = JSONDecoder()
                if let savedUser = try? decoder.decode(UserProfile.self, from: savedUserData) {
                    self.userInfoDetail = savedUser
                    self.eventHandler?(.dataLoaded)
                    return
                }
            }
        }
        
        
    }
    
    func updateUserDetail(params: UpdateProfile) {
        self.eventHandler?(.loading)
        let parameter = try? APIManager.shared.encodeBody(value: params)
        print(params)
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.updateProfile, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                Contanst.userdefault.removeObject(forKey: "userInfoDetail")
                self.eventHandler?(.updateProfile)
            case .failure(let error):
                if case DataError.invalidResponse400(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }
            }
            
        })
    }
    
    func logout() {
        if let infoToken = try? TokenService.tokenInstance.decode(jwtToken: TokenService.tokenInstance.getToken(key: "userToken")) {
           
            if Date().timeIntervalSince1970.isLessThanOrEqualTo(infoToken["exp"]! as! Double) {
                self.eventHandler?(.loading)
                APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.logout, params: nil, completion: {
                    result in
                    self.eventHandler?(.stopLoading)
                    switch result {
                    case .success(let data):
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self.eventHandler?(.logout)
                    case .failure(let error):
                        if case DataError.invalidResponse400(let reason) = error {
                            self.eventHandler?(.error(reason))
                        }
                        else {
                            self.eventHandler?(.error(error.localizedDescription))
                        }
                    }
                })
            } else {
                TokenService.tokenInstance.removeTokenAndInfo()
                self.eventHandler?(.logout)
            }
            
        }
        
        
    }
    
    
}

extension ProfileViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
        case logout
        case updateProfile
//        case newProductAdded(product: AddProduct)
    }

}
