//
//  ProductEndPoint.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 15/01/23.
//

import Foundation

enum UserEndPoint {
    case profile // Module - GET
    case login(infoLogin: InfoLogin) // POST
    case logout // POST
    case updateProfile // PUT
    case changePassword // PUT
    case forgetPassword // POST
    case sendOTP // POST
    case verifyToken(token: String) // GET
    case refreshToken(token: String) // POST
    case uploadAvatar // PUT
    case me  // GET

}

// https://fakestoreapi.com/products
extension UserEndPoint: EndPointType {
    

    var path: String {
        switch self {
        case .profile:
            return "api/v1/user-auth/user/my-profile"
        case .login:
            return "api/v1/user-auth/user/sign-in"
        case .logout:
            return "api/v1/user-auth/user/log-out"
        case .updateProfile:
            return "api/v1/user-auth/user/update-profile"
        case.changePassword:
            return "api/v1/user-auth/user/update-password"
        case.forgetPassword:
            return "api/v1/user-auth/user/forget-password"
        case .verifyToken(let query):
            return "api/v1/user-auth/user/verify/\(query)"
        case .refreshToken(let query):
            return "api/v1/user-auth/user/refresh-token?refreshToken=Bearer%20\(query)"
        case .sendOTP:
            return "api/v1/user-auth/user/send-otp"
        case .uploadAvatar:
            return "api/v1/user-auth/user/upload-avatar"
        case .me:
            return "api/v1/user-auth/user/me"
        }
   

    }

    var baseURL: String {
//        return ProcessInfo.processInfo.environment["BASE_URL"]!
        return "https://api.hcmus.online/"
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .profile:
            return .get
        case .login:
            return .post
        case .logout:
            return .post
        case .updateProfile:
            return .put
        case .changePassword:
            return .put
        case .forgetPassword:
            return .post
        case .verifyToken:
            return .get
        case .refreshToken:
            return .post
        case .sendOTP:
            return .post
        case .uploadAvatar:
            return .put
        case .me:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .profile:
            return nil
        case .login(let Info):
            return Info
        case .logout:
            return nil
        case .updateProfile:
            return nil
        case .changePassword:
            return nil
        case .forgetPassword:
            return nil
        case .verifyToken:
            return nil
        case .refreshToken:
            return nil
        case .sendOTP:
            return nil
        case .uploadAvatar:
            return nil
        case .me:
            return nil
        }
    
    }

    var headers: [String : String]? {
        switch self {
        case .profile:
            return APIManager.bearTokenHeaders
        case .login(let infoLogin):
            return APIManager.commonHeaders
        case .logout:
            return APIManager.bearTokenHeaders
        case .updateProfile:
            return APIManager.bearTokenHeaders
        case .changePassword:
            return APIManager.bearTokenHeaders
        case .forgetPassword:
            return APIManager.commonHeaders
        case .verifyToken:
            return APIManager.commonHeaders
        case .refreshToken:
            return APIManager.commonHeaders
        case .sendOTP:
            return APIManager.commonHeaders
        case .uploadAvatar:
            return APIManager.bearTokenHeaders
        case .me:
            return APIManager.bearTokenHeaders
        }
    }
}
