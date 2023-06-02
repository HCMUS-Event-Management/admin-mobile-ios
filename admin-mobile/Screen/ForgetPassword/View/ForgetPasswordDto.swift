//
//  ForgetPasswordDto.swift
//  mobile
//
//  Created by NguyenSon_MP on 19/04/2023.
//

import Foundation
struct ForgetpasswordDto: Codable {
    var email: String?
    var otp: String?
    var password: String?
    var verifiedPassword: String?
}
