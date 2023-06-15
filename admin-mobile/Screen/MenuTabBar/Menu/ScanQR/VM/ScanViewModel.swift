//
//  ScanViewModel.swift
//  admin-mobile
//
//  Created by NguyenSon_MP on 16/04/2023.
//

import Foundation
import Reachability

class ScanViewModel {

    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func vadilateTicket(from info: VadilateTicketDto) {
        self.eventHandler?(.loading)
        let parameter = try? APIManager.shared.encodeBody(value: info)
        APIManager.shared.request(modelType: ReponseValidateTicket.self, type: EntityEndPoint.validate, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let value):
                self.eventHandler?(.vadilateTicket)
            case .failure(let error):
                if case DataError.invalidResponse(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }
            }
        })
    }
    
    func checkVadilateTicket(from info: VadilateTicketDto) {
        switch try! Reachability().connection {
          case .wifi:
            vadilateTicket(from: info)
          case .cellular:
            vadilateTicket(from: info)
          case .none:
            self.eventHandler?(.error("Mất kết nối mạng"))
          case .unavailable:
            self.eventHandler?(.error("Mất kết nối mạng"))
        }
    }


}

extension ScanViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
        case vadilateTicket
//        case newProductAdded(product: AddProduct)
    }

}
