//
//  EventsViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/05/2023.
//

import Foundation
import Reachability
class EventsViewModel {
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var catagorys = [CategoryObject]()
    var events = [DataEventObject]()
    
    
    func fetchCategoryAll() {
        switch try! Reachability().connection {
          case .wifi:
            getCategoryAllFromServer()
          case .cellular:
            getCategoryAllFromServer()
          case .none:
            getCategoryAllFromDB()
          case .unavailable:
            getCategoryAllFromDB()

        }
    }
    
    func getCategoryAllFromDB() {
        self.catagorys = [CategoryObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(CategoryObject.self)
            for i in temp {
                self.catagorys.append(i)
            }
        }
        self.eventHandler?(.categoryLoaded)
    }
    
    func getCategoryAllFromServer() {
        self.eventHandler?(.loading)

        APIManager.shared.request(modelType: ReponseGetAllCategory.self, type: EntityEndPoint.getAllCategory, params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let value):
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.catagorys.append(i.managedObject())
                    }
                }
                self.eventHandler?(.categoryLoaded)
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
    
    func fetchListEventOfUser(fullTextSearch: String) {
        switch try! Reachability().connection {
          case .wifi:
            getListEventOfUserFromServer(fullTextSearch: fullTextSearch)
          case .cellular:
            getListEventOfUserFromServer(fullTextSearch: fullTextSearch)
          case .none:
            getListEventOfUserFromDB(fullTextSearch: fullTextSearch)
          case .unavailable:
            getListEventOfUserFromDB(fullTextSearch: fullTextSearch)

        }
    }
    
    
    
    func getListEventOfUserFromDB(fullTextSearch: String) {
        self.events = [DataEventObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(DataEventObject.self)
            for i in temp.filter("category.label == '\(fullTextSearch)'") {
                self.events.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    func getListEventOfUserFromServer(fullTextSearch: String) {
        self.eventHandler?(.loading)

        APIManager.shared.request(modelType: ReponseListEvent.self, type: EntityEndPoint.listEventOfUser(page: 1, perPage: 10, filterStatus: "APPROVED", sort: "", fullTextSearch: fullTextSearch, type: ""), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let value):
                self.events = [DataEventObject]()
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.events.append(i.managedObject())
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
    
}

extension EventsViewModel {
    func fetchListEventOfManagerUser(fullTextSearch: String) {
        switch try! Reachability().connection {
          case .wifi:
            getListEventOfManagerUserFromServer(fullTextSearch: fullTextSearch)
          case .cellular:
            getListEventOfManagerUserFromServer(fullTextSearch: fullTextSearch)
          case .none:
            getListEventOfManagerUserFromDB(fullTextSearch: fullTextSearch)
          case .unavailable:
            getListEventOfManagerUserFromDB(fullTextSearch: fullTextSearch)

        }
    }
    
    
    func getListEventOfManagerUserFromDB(fullTextSearch: String) {
        self.events = [DataEventObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(DataEventObject.self)
            for i in temp.filter("category.label == '\(fullTextSearch)'") {
                self.events.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    func getListEventOfManagerUserFromServer(fullTextSearch: String) {
        self.eventHandler?(.loading)

        APIManager.shared.request(modelType: ReponseListEvent.self, type: EntityEndPoint.listEventOfManagerUser(page: 1, perPage: 10, filterStatus: "APPROVED", sort: "", fullTextSearch: fullTextSearch, type: ""), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let value):
                self.events = [DataEventObject]()
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.events.append(i.managedObject())
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
}

extension EventsViewModel {

    enum Event {
        case loading
        case stopLoading
        case categoryLoaded
        case dataLoaded
        case error(String?)
    }

}
