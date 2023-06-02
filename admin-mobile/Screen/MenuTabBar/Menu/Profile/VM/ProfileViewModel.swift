//
//  ProfileAccountViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 04/03/2023.
//

import Foundation
import Reachability

final class ProfileViewModel {
    var userInfo: GetUserInfor?
    var userInfoDetail: UserProfile?

    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    
    func uploadAvatar(imageData: Data?) {
        self.eventHandler?(.loading)

        let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//            let strBase64 = im
        let avatar = UploadAvatarDto(data: imageStr)
        

        let parameter = try? APIManager.shared.encodeBody(value: avatar)
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.uploadAvatar, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                self.eventHandler?(.updateProfile)
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
    
    
    func updateUserDetail(params: UpdateProfile) {
        self.eventHandler?(.loading)
        let parameter = try? APIManager.shared.encodeBody(value: params)
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.updateProfile, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                Contanst.userdefault.removeObject(forKey: "userInfoDetail")
                self.eventHandler?(.updateProfile)
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
                        if case DataError.invalidResponse(let reason) = error {
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


extension ProfileViewModel {
    
    
    
    func fetchUserDetail() {

        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getUserDetailFromSever()
          case .cellular:
              print("Reachable via Cellular")
            getUserDetailFromSever()
          case .none:
              print("Network not reachable")
              getUserDetailFromLocalDB()
          case .unavailable:
              print("Network not reachable")
              getUserDetailFromLocalDB()
        }
    }
    
    func getUserDetailFromLocalDB() {
        if let savedUserData = Contanst.userdefault.object(forKey: "userInfoDetail") as? Foundation.Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(UserProfile.self, from: savedUserData) {
                self.userInfoDetail = savedUser
                self.eventHandler?(.dataLoaded)
                return
            }
        }
    }
    func getUserDetailFromSever() {
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
