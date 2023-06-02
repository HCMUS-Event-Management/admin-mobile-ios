//
//  UploadAvatarDto.swift
//  mobile
//
//  Created by NguyenSon_MP on 22/04/2023.
//

import Foundation


struct UploadAvatarDto: Codable {
    var mime: String = "image/(format_file: jpeg/jpg/png)"
    var data: String?
}
