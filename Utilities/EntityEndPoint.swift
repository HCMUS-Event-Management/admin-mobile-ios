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
    case search(query: String)
    case listGoingOnEvent(page: Int, perPage: Int, filterStatus: String, sort: String, fullTextSearch: String, type: String)
    case listIsCommingEvent(page: Int, perPage: Int, filterStatus: String, sort: String, fullTextSearch: String, type: String)
    case eventDetail(id: Int)
    case getAllCategory
    case listEventOfUser(page: Int, perPage: Int, filterStatus: String, sort: String, fullTextSearch: String, type: String)
}


extension EntityEndPoint: EndPointType {
    var body: Encodable? {
        return nil
    }
    
    var headers: [String : String]? {
        switch self {
        case .myTicket:
            return APIManager.bearTokenHeaders
        case .ticketDetail:
            return APIManager.bearTokenHeaders
        case .boughtTicket:
            return APIManager.bearTokenHeaders
        case .eventDetail:
            return APIManager.commonHeaders
        case .search:
            return APIManager.commonHeaders
        case .listGoingOnEvent:
            return APIManager.commonHeaders
        case .listIsCommingEvent:
            return APIManager.commonHeaders
        case .getAllCategory:
            return APIManager.commonHeaders
        case .listEventOfUser:
            return APIManager.commonHeaders
        }
    }
    
    
    var path: String {
        switch self {
            
        case .myTicket(page: let page, perPage: let perPage):
            return "api/v1/entity/ticket/my?page=\(page)&perPage=\(perPage)"
        case .ticketDetail(ticketCode: let ticketCode):
            return "api/v1/entity/ticket/\(ticketCode)"
        case .boughtTicket(page: let page, perPage: let perPage):
            return "api/v1/entity/ticket/bought?page=\(page)&perPage=\(perPage)"
        case .search(query: let query):
            return "api/v1/entity/event/search?query=\(query)"
        case .listGoingOnEvent(page: let page, perPage: let perPage, filterStatus: let filterStatus, sort: let sort, fullTextSearch: let fullTextSearch, type: let type):
            return "api/v1/entity/event/get-list-going-on-event?page=\(page)&perPage=\(perPage)&filterStatus=\(filterStatus)&sort=\(sort)&fullTextSearch=\(fullTextSearch)&type=\(type)"
        case .listIsCommingEvent(page: let page, perPage: let perPage, filterStatus: let filterStatus, sort: let sort, fullTextSearch: let fullTextSearch, type: let type):
            return "api/v1/entity/event/get-list-is-coming-event?page=\(page)&perPage=\(perPage)&filterStatus=\(filterStatus)&sort=\(sort)&fullTextSearch=\(fullTextSearch)&type=\(type)"
        case .eventDetail(id: let id):
            return "api/v1/entity/event/get-detail-event/\(id)"
        case .getAllCategory:
            return "api/v1/entity/category/get-all"
        case .listEventOfUser(page: let page, perPage: let perPage, filterStatus: let filterStatus, sort: let sort, fullTextSearch: let fullTextSearch, type: let type):
            return "api/v1/entity/event/get-list-event-user?page=\(page)&perPage=\(perPage)&filterStatus=\(filterStatus)&sort=\(sort)&fullTextSearch=\(fullTextSearch)&type=\(type)"
        }
    }
    
    var baseURL: String {
        return "https://api.hcmus.online/"
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
        case .search:
            return .get
        case .listGoingOnEvent:
            return .get
        case .eventDetail:
            return .get
        case .listIsCommingEvent:
            return .get
        case .getAllCategory:
            return .get
        case .listEventOfUser:
            return .get
        }
    }
    
}
