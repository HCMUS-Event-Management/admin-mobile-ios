//
//  UpdateProfile.swift
//  mobile
//
//  Created by NguyenSon_MP on 06/03/2023.
//

import Foundation

struct UpdateProfile: Codable {
    let fullName : String?
    let phone : String?
    let birthday : String?
    let identityCard : String?
    let gender : String?
    let address : String?
    let image: UploadAvatarDto?
}
