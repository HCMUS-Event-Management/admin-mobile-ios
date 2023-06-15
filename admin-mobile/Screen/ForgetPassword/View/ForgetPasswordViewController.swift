//
//  ForgetPasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 12/03/2023.
//

import UIKit
import Reachability
class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var btnGetNewPass: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEmail: UITextField!

    
    private var VM = ForgetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGetNewPass.addTarget(self, action: #selector(postAPI), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnGetNewPass.layer.cornerRadius = 20
        btnGetNewPass.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 20
        btnBack.layer.masksToBounds = true
        btnBack.layer.borderWidth = 0.5
        btnBack.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
    }
    
    @objc func back () {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postAPI () {
        if txtEmail.text == ""{
            self.showToast(message: "Điền Email vào", font: .systemFont(ofSize: 12.0))
        } else if (!(txtEmail.text?.isValidEmail() ?? false)) {
            self.showToast(message: "Không phải Email", font: .systemFont(ofSize: 12.0))
        } else {
            
            switch try! Reachability().connection {
              case .wifi:
                let params = SendOTPDto(email: txtEmail.text, type: "FORGET_PASSWORD")
                VM.sendOTPForget(from: params)              case .cellular:
                let params = SendOTPDto(email: txtEmail.text, type: "FORGET_PASSWORD")
                VM.sendOTPForget(from: params)              case .none:
                showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
              case .unavailable:
                showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
            }
        }
       
        
        
    }
    

}



extension ForgetPasswordViewController {

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.changeScreen(modelType: ForgetPassword2ViewController.self,id: "ForgetPassword2ViewController")
                }
            case .error(let error):
                print(error)
//                let err = error as! DataError
                if (error == DataError.invalidResponse500.localizedDescription){
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
                

            case .invalid:
                break
            }
        }
    }

}


