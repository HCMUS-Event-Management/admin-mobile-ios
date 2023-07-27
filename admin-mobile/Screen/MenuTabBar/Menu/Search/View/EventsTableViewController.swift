//
//  AppsTableViewController.swift
//  AppStoreSearch
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Marcos Griselli. All rights reserved.
//

import UIKit
import Kingfisher
import Reachability

class EventsTableViewController: UITableViewController {
    var callback : (() -> Void)?
    var VM = SearchViewModel()
    var hiddenHeaderSections: [Int: Bool] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if VM.apps.count == 0 {
            return 1
        } else {
            return VM.apps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if VM.apps.count == 0 {
        } else {
            Contanst.userdefault.set(VM.apps[indexPath.row].id, forKey: "eventIdDetail")
            callback?()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if VM.apps.count == 0 {
            let cell: EmptyTableViewCell =
                tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        } else {
            let cell: EventTableViewCell =
                tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

            cell.configure(app: VM.apps[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EventTableViewCell else { return }
        cell.cancel()
    }
    


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if VM.apps.count == 0 {
            return tableView.layer.frame.height
        } else {
            return tableView.layer.frame.height / 5
        }
    }
    

    func search(apps: [DataReponseSearch]) {
        
        self.VM.apps = apps
        self.tableView.reloadData()
//        switch try! Reachability().connection {
//          case .wifi:
//            VM.search(term: term)
//          case .cellular:
//            VM.search(term: term)
//          case .none:
//            showToast(message: "Network not reachable", font: .systemFont(ofSize: 12))
//          case .unavailable:
//            showToast(message: "Network not reachable", font: .systemFont(ofSize: 12))
//        }
    }
}


extension EventsTableViewController {

    func configuration() {
        tableView.register(EventTableViewCell.self)
        tableView.register(EmptyTableViewCell.self)

        tableView.separatorStyle = .none
        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
