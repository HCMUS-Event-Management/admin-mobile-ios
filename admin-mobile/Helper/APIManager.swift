//
//  APIManager.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 23/12/22.
//

import Foundation
import UIKit

enum DataError: Error, Equatable {
    
    static func == (lhs: DataError, rhs: DataError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidResponse
    case invalidResponse400(String?)
    case invalidResponse401
    case invalidResponse500
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias Handler<T> = (Swift.Result<T, DataError>) -> Void


final class APIManager {
    let queue = DispatchQueue(label: "FetchUserDetail")
    static let shared = APIManager()
    private var checkRefreshToken = 0
    private init() {}
    func encodeBody<T: Encodable>(value: T) throws -> Foundation.Data? {
        let data = try? JSONEncoder().encode(value)
        return data
    }
    
    func loginByRefresh(completion: @escaping Handler<ReponseLogin>) {
        request(modelType: ReponseLogin.self , type: UserEndPoint.refreshToken(token: Contanst.userdefault.string(forKey: "refreshToken") ?? ""), params: nil, completion: {
            result in
            switch result {
            case .success(let info):
                TokenService.tokenInstance.saveToken(token: info.data?.accessToken ?? "", refreshToken: Contanst.userdefault.string(forKey: "refreshToken") ?? "")
                if let encodedUser = try? JSONEncoder().encode(info.data?.getUserInfor) {
                    Contanst.userdefault.set(encodedUser, forKey: "userInfo")
                }
                
                completion(.success(info))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func handleTaskSession<T: Codable>(modelType: T.Type,
                                       type: EndPointType, params: Foundation.Data?, request: URLRequest ,completion: @escaping Handler<T>) -> URLSessionDataTask {
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            print(response)

            
            if let response = response as? HTTPURLResponse,
                  400 ~= response.statusCode {
//
                do {
                    let dataType = try JSONDecoder().decode(ReponseError.self, from: data)
                    completion(.failure(.invalidResponse400(String((dataType.message?.split(separator: ";")[0])!) as String)))
                    return
                }catch {
                    completion(.failure(.network(error)))
                }
                
            }
            
            if let response = response as? HTTPURLResponse,
                  401 ~= response.statusCode {
                var tastAgain: URLSessionDataTask?
                
                let tokenInstance = TokenService.tokenInstance
                
                // sợ lặp
                if self.checkRefreshToken >= 1 {
                    self.checkRefreshToken = 0
                    completion(.failure(.invalidResponse401))
                    return
                }
                if (tokenInstance.getToken(key: "refreshToken") == "") {
                    return
                }
                
                
//                test
//                if (tokenInstance.getToken(key: "refreshToken") != "") {
//                    if let refreshToken = try? tokenInstance.decode(jwtToken: tokenInstance.getToken(key: "refreshToken")) {
//                        if Date.now.timeIntervalSince1970.isLessThanOrEqualTo(refreshToken["exp"]! as! Double) {
//                            print("còn hạn")
//                        } else {
//                            completion(.failure(.invalidResponse401))
//                            return
//                            print("hết hạn")
//                        }
//                    } else {
//                        print("hết hạn")
//                    }
//                } else {
//                    print("hết hạn")
//                }
                
                self.checkRefreshToken+=1
                self.loginByRefresh(completion: {
                    result in
                    switch result {
                    case .success(_):

                        self.checkRefreshToken = 0
                        
                        guard let url = type.url else {
                            completion(.failure(.invalidURL)) // I forgot to mention this in the video
                            return
                        }

                        var rq = URLRequest(url: url)
                        rq.httpMethod = type.method.rawValue

                        if (params != nil) {
                            rq.httpBody = params
                        }

                        rq.allHTTPHeaderFields = type.headers

                        
                        self.handleTaskSession(modelType: modelType, type: type, params: params, request: rq, completion:  {
                            result in
                            switch result {
                            case .success(let value):
                                completion(.success(value))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                         }).resume()
                        

                    case .failure(let error):
                        self.checkRefreshToken = 0
                        completion(.failure(error))
                    }
                    
                    return
                    
                })
                
                
                
            }
            
            if let response = response as? HTTPURLResponse,
                  500 ~= response.statusCode {
                do {
                    let dataType = try JSONDecoder().decode(ReponseError.self, from: data)
                }catch {
                    completion(.failure(.network(error)))
                }
                completion(.failure(.invalidResponse500))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               200 ... 299 ~= response.statusCode {
                do {
                    let dataType = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(dataType))
                }catch {
                    completion(.failure(.network(error)))
                }
            }
            
            

        }
        
        return task
        
    }
    
    func request<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        params: Foundation.Data?,
        completion: @escaping Handler<T>
    ) {

        guard let url = type.url else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if (params != nil) {
            request.httpBody = params
        }

        request.allHTTPHeaderFields = type.headers
        
        let task = handleTaskSession(modelType: modelType, type: type, params: params, request: request, completion: {
            result in
            switch result {
                
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                print(error)
                completion(.failure(error))

            }
        })
        
        // Background task
        task.resume()
    }
    
    
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    static var bearTokenHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(TokenService.tokenInstance.getToken(key: "userToken"))",
        ]
    }
}
