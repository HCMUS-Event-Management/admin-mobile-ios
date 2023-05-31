//
//  PaymentEndPoint.swift
//  mobile
//
//  Created by NguyenSon_MP on 18/05/2023.
//


import Foundation

enum PaymentEndPoint {
    case paymentHistory (page: Int, perPage: Int)
}


extension PaymentEndPoint: EndPointType {
    var body: Encodable? {
        return nil
    }
    
    var headers: [String : String]? {
        switch self {
        case .paymentHistory:
            return APIManager.bearTokenHeaders
        }
    }
    
    
    var path: String {
        switch self {
        case .paymentHistory(page: let page, perPage: let perPage):
            return "api/v1/payment/payment-request/history?page=\(page)&perPage=\(perPage)"
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
        case .paymentHistory:
            return .get
        }
    }
    
}
