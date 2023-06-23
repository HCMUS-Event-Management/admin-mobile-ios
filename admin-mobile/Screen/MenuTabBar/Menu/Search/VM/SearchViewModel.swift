//
//  SearchViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/05/2023.
//

import Foundation


class SearchViewModel {
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var apps = [DataReponseSearch]()

    /// - Parameter term: Term to search.
    func search(term: String) {
        self.eventHandler?(.loading)
        let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        APIManager.shared.request(modelType: ReponseSearch.self, type: EntityEndPoint.search(query: encodedTerm  ?? String()), params: nil, completion: { result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let data):
                self.apps = data.data ?? [DataReponseSearch]()
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


extension SearchViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
    }

}
