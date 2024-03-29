//
//  ForgetPassword2ViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 12/03/2023.
//

import UIKit

class ForgetPassword2ViewController: UIViewController {

    @IBOutlet weak var otpCode: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnConfirm.addTarget(self, action: #selector(postAPI), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        showToast(message: "OTP đã gửi về Gmail của bạn", font: .systemFont(ofSize: 12))

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        btnConfirm.layer.cornerRadius = 20
        btnConfirm.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 20
        btnBack.layer.masksToBounds = true
        btnBack.layer.borderWidth = 0.5
        btnBack.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
    }
    @objc func postAPI () {
        if otpCode.text == ""{
            self.showToast(message: "Điền OTP", font: .systemFont(ofSize: 12))
        } else {
            Contanst.userdefault.set(otpCode.text, forKey: "otp")
            self.changeScreen(modelType: ForgetPassword3ViewController.self, id: "ForgetPassword3ViewController")
        }

    }
    @objc func back () {
        self.navigationController?.popViewController(animated: true)
    }
}
