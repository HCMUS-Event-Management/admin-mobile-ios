//
//  EntityEndPoint.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation

enum EntityEndPoint {
    case myTicket(page: Int, perPage: Int)
    case ticketDetail(ticketCode: String)
    case boughtTicket(page: Int, perPage: Int)
}


extension EntityEndPoint: EndPointType {
    var path: String {
        switch self {
            
        case .myTicket(page: let page, perPage: let perPage):
            return "api/v1/entity/ticket/my?page=\(page)&perPage=\(perPage)"
        case .ticketDetail(ticketCode: let ticketCode):
            return "api/v1/entity/ticket/\(ticketCode)"
        case .boughtTicket(page: let page, perPage: let perPage):
            return "api/v1/entity/ticket/bought?page=\(page)&perPage=\(perPage)"
        }
    }
    
    var baseURL: String {
        return ProcessInfo.processInfo.environment["BASE_URL"]!
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .myTicket:
            return .get
        case .ticketDetail:
            return .get
        case .boughtTicket:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .myTicket:
            return nil
        case .ticketDetail:
            return nil
        case .boughtTicket:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myTicket:
            return APIManager.bearTokenHeaders
        case .ticketDetail:
            return APIManager.bearTokenHeaders
        case .boughtTicket:
            return APIManager.bearTokenHeaders
        }
    }
    
    
}
