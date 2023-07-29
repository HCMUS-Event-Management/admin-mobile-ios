//
//  ResultsContainerViewController.swift
//  AppStoreSearch
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Marcos Griselli. All rights reserved.
//

import UIKit
import Reachability
class ResultsContainerViewController: ContentStateViewController {
    
    private var suggestionsViewController: SuggestedTermsTableViewController!
    var didSelect: (String) -> Void = { _ in }
    var callback : (() -> Void)?
    var VM = SearchViewModel()
    let appsListViewController = EventsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        suggestionsViewController = storyboard.instantiateViewController(withIdentifier: "SuggestedTermsTableViewController") as? SuggestedTermsTableViewController
        suggestionsViewController.didSelect = didSelect
    }
    
    /// Manages the view controller that needs to be displayed.
    ///
    /// - Parameters:
    ///   - term: term to search
    ///   - searchType: type of search being performed.
    func handle(term: String, searchType: SearchType) {
        
        /// For this case both view controllers are already
        /// properties of this class but we could create them
        /// at this point and discard them when using a new one.
        switch searchType {
        case .partial:
            suggestionsViewController.searchedTerm = term
            transition(to: .render(suggestionsViewController))
        case .final:
            /// We create a new view controller because the
            /// final search is a lot less frequent than the
            /// active suggestions.
            switch try! Reachability().connection {
              case .wifi:
                VM.search(term: term)
              case .cellular:
                VM.search(term: term)
              case .none:
                showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
              case .unavailable:
                showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
            }
            appsListViewController.callback = {
                self.callback?()
            }
            transition(to: .render(appsListViewController))
        }
    }
}


extension ResultsContainerViewController {

    func configuration() {
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        
    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?

        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.appsListViewController.search(apps: self?.VM.apps ?? [DataReponseSearch]())
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .error(let error):
//                let err = error as! DataError
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                } else if (error == DataError.invalidResponse500.localizedDescription){
                    DispatchQueue.main.async {
                        self?.showToast(message: "Chưa kết nối mạng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
            }
        }

    }
}
