//
//  HomeViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 15/05/2023.
//

import Foundation
import Reachability

class HomeViewModel {

    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var goingOnEvent = [DataEventObject]()
    var isCommingEvent = [DataEventObject]()
    var detailEvent = EventDetailObject()

}


// detail Event

extension HomeViewModel {
    func getDetailEventFromServer(_ id: Int) {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseDetailEvent.self, type: EntityEndPoint.eventDetail(id: id), params: nil, completion: { result in
            self.eventHandler?(.stopLoading)

            switch result {
                case .success(let detail):
                    self.detailEvent = (detail.data?.eventDetail?.managedObject())!
                    self.eventHandler?(.dataLoaded)
                    
                case .failure(let error):
                    if case DataError.invalidResponse(let reason) = error {
                        self.eventHandler?(.error(reason))
                    }
                    else {
                        self.eventHandler?(.error(error.localizedDescription))
                    }
            }})
    }
    
    func getDetailEventFromDB(_ id: Int) {
        let container = try! Container()

        try! container.write{
            transaction in
            let items = transaction.get(EventDetailObject.self)
            for item in items.filter("id == '\(id)'") {
                self.detailEvent = item
                self.eventHandler?(.dataLoaded)
            }
        }
    }
    
    func fetchDetailEvent(_ id: Int) {
        
        
        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getDetailEventFromServer(id)
          case .cellular:
              print("Reachable via Cellular")
            getDetailEventFromServer(id)
          case .none:
              print("Network not reachable")
            self.eventHandler?(.error("Mất kết nối internet"))
          case .unavailable:
              print("Network not reachable")
            self.eventHandler?(.error("Mất kết nối internet"))
        }

    }
    
}

extension HomeViewModel {
    
    func getListGoingOnFromServer() {
        APIManager.shared.request(modelType: ReponseListEvent.self, type: EntityEndPoint.listGoingOnEvent(page: 1, perPage: 10, filterStatus: "APPROVED", sort: "", fullTextSearch: "", type: ""), params: nil, completion: {
            result in
            switch result {
            case .success(let value):
                
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.goingOnEvent.append(i.managedObject())
                    }
                }
                self.eventHandler?(.dataLoaded)

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
    
    func getListGoingOnFromDB() {
        self.goingOnEvent = [DataEventObject]()
        let container = try! Container()
        let now = Date();
        try! container.write{
            transaction in
            let temp = transaction.get(DataEventObject.self)
            for i in temp.filter("%@ >= startAt AND %@ <= endAt", now, now){
                self.goingOnEvent.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    
    func fetchListGoingOn() {
        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getListGoingOnFromServer()
          case .cellular:
              print("Reachable via Cellular")
            getListGoingOnFromServer()
          case .none:
              print("Network not reachable")
              getListGoingOnFromDB()
          case .unavailable:
              print("Network not reachable")
            getListGoingOnFromDB()
        }
    }
    
    
    
    func getListIsCommingFromServer() {
        APIManager.shared.request(modelType: ReponseListEvent.self, type: EntityEndPoint.listIsCommingEvent(page: 1, perPage: 10, filterStatus: "APPROVED", sort: "", fullTextSearch: "", type: ""), params: nil, completion: {
            result in
            switch result {
            case .success(let value):
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.isCommingEvent.append(i.managedObject())
                    }
                }
                self.eventHandler?(.dataLoaded)
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
    
    
    
    func getListIsCommingFromDB() {
        self.isCommingEvent = [DataEventObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(DataEventObject.self)
            let now = Date();
            let threeDaysLater = Date(timeIntervalSinceNow: 30 * 24 * 60 * 60);

            for i in temp.filter("startAt BETWEEN {%@, %@}", now , threeDaysLater) {
                self.isCommingEvent.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    
    func fetchListIsComming() {
        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getListIsCommingFromServer()
          case .cellular:
              print("Reachable via Cellular")
            getListIsCommingFromServer()
          case .none:
              print("Network not reachable")
            getListIsCommingFromDB()
          case .unavailable:
              print("Network not reachable")
            getListIsCommingFromDB()
        }
    }
    
    
    
    func getListEventForHome() {
        self.eventHandler?(.loading)
        self.fetchListGoingOn()
        self.fetchListIsComming()
    }
    
}


extension HomeViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
    }

}
