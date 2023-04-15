//
//  ReponseError.swift
//  mobile
//
//  Created by NguyenSon_MP on 28/03/2023.
//

import Foundation


struct ReponseError : Codable {
    let statusCode : Int?
    let message : String?
    let error : String?


    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
        case error = "error"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(String.self, forKey: .error)

    }

}
