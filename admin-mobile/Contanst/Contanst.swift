//
//  Contanst.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import Foundation

enum Contanst {
//     ?? "http://localhost:3000"
    enum API {
        static var loginURL = ProcessInfo.processInfo.environment["BASE_URL"]! + "/api/v1/user/sign-in"
    }
    
    static let userdefault = UserDefaults.standard
}
