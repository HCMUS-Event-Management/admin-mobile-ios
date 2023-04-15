//
//  ReponseLogout.swift
//  mobile
//
//  Created by NguyenSon_MP on 06/03/2023.
//

import Foundation

struct ReponseCommon : Codable {
    let statusCode : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
