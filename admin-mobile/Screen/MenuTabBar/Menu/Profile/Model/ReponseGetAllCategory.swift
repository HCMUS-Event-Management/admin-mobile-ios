//
//  ReponseGetAllCategory.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/05/2023.
//

import Foundation

struct ReponseGetAllCategory : Codable {
    let status : Int?
    let message : String?
    let data : [Category]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([Category].self, forKey: .data)
    }

}

