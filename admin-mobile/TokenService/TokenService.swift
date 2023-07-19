//
//  TokenService.swift
//  mobile
//
//  Created by NguyenSon_MP on 08/03/2023.
//

import Foundation


typealias CompletionHandler = (_ success:Bool) -> Void

class TokenService {
    static let tokenInstance = TokenService()
    
    
    
    func saveToken(token: String, refreshToken: String) {
        Contanst.userdefault.set(token, forKey: "userToken")
        Contanst.userdefault.set(refreshToken, forKey: "refreshToken")
    }
    
    func getToken(key: String) -> String {
        if let token = Contanst.userdefault.object(forKey: key) as? String {
            return token
        } else {
            return ""
        }
    }
    
    
    
    func checkForLogin(completionHandler: @escaping CompletionHandler) {
        let now = NSDate.now.timeIntervalSince1970

        if (getToken(key: "userToken") != "" && getToken(key: "refreshToken") != "") {
            if let infoToken = try? decode(jwtToken: getToken(key: "userToken")) {
                if now.isLessThanOrEqualTo(infoToken["exp"]! as! Double) {
                    completionHandler(true)
                } else {
                    if let refreshToken = try? decode(jwtToken: getToken(key: "refreshToken")) {
                        if now.isLessThanOrEqualTo(refreshToken["exp"]! as! Double) {
                            // check mạng chỗ này
                            return loginByRefreshToken(completion: {
                                result in
                                switch result {
                                case .success(_):
                                    completionHandler(true)
                                case .failure(let err):
                                    completionHandler(false)
                                }
                            })
                            
                        } else {
                            completionHandler(false)
                        }
                    }
                }
            }
        } else {
            completionHandler(false)
        }
        
        
        

    }
    func loginByRefreshToken(completion: @escaping Handler<ReponseLogin>) {
        APIManager.shared.loginByRefresh(completion: {
            result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }
    
    func removeTokenAndInfo() {
        Contanst.userdefault.removeObject(forKey: "userInfoDetail")
        Contanst.userdefault.removeObject(forKey: "userInfo")
        Contanst.userdefault.removeObject(forKey: "userToken")
        Contanst.userdefault.removeObject(forKey: "refreshToken")
        

    }
}

extension TokenService{
    func decode(jwtToken jwt: String) throws -> [String: Any] {

        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Foundation.Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Foundation.Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
}
