//
//  ForgetPassword3ViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/04/2023.
//

import UIKit

class ForgetPassword3ViewController: UIViewController {
    private var VM = ForgetPasswordViewModel()

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDone.addTarget(self, action: #selector(postAPI), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        // Do any additional setup after loading the view.
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnDone.layer.cornerRadius = 20
        btnDone.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 20
        btnBack.layer.masksToBounds = true
        btnBack.layer.borderWidth = 0.5
        btnBack.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
    }
    
    @objc func postAPI () {
        if txtNewPass.text == "" || txtConfirmPass.text == ""{
            print("emtyp")
        } else {
            let param = ForgetpasswordDto(email: Contanst.userdefault.string(forKey: "email"), otp:  Contanst.userdefault.string(forKey: "otp"), password: txtNewPass.text, verifiedPassword: txtConfirmPass.text)
            VM.forgetPassword(from: param)
        }

    }
    @objc func back () {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ForgetPassword3ViewController {

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
                self?.stoppedLoader(loader: loader ?? UIAlertController())
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.showToast(message: "Đổi mật khẩu thành công", font: .systemFont(ofSize: 12))
                    self?.changeScreen(modelType: LoginFirstScreenViewController.self,id: "LoginFirstScreenViewController")
                }
            case .error(let error):
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
