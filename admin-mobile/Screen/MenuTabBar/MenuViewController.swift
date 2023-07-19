//
//  MenuViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 04/03/2023.
//

import UIKit

class MenuViewController: UITabBarController {

    var LoginFirstViewModel = LoginFirstScreenViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        print(TokenService.tokenInstance.getToken(key: "userToken"))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //khoá xoay màn hình
        self.showToast(message: "Bạn đã đăng nhập", font: .systemFont(ofSize: 12))
    }
}

extension MenuViewController {

    func configuration() {
        initViewModel()
        observeEvent()
    
    }

    func initViewModel() {
//        LoginFirstViewModel.fetchUserDetail()
//        TickeViewModel.fetchMyTicket()
//        TickeViewModel.fetchBoughtTicket()


    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?

        LoginFirstViewModel.eventHandler = { [weak self] event in
            switch event {
            case .loading: break
            case .stopLoading: break
            case .dataLoaded: break
            case .error(let error):
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                }
            case .invalid: break
            case .permission:
                break
            }
        }
    }
}
