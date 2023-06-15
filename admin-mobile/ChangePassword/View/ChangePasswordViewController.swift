//
//  ChangePasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit
import Reachability
class ChangePasswordViewController: UIViewController {
    var dataLabel = ["Mật khẩu hiện tại:","Mật khẩu mới:","Xác nhận mật khẩu mới:"]
    var VM = ChangePasswordViewModel()

    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Đổi mật khẩu"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
    }

}


extension ChangePasswordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == dataLabel.count){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileButtonTableViewCell", for: indexPath) as? EditProfileButtonTableViewCell {
                cell.delegate = self
                cell.btnSelect.setTitle("Thay đổi", for: .normal)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row]
                return cell
            }
        }

        return UITableViewCell()

    }
    
    
    
}


extension ChangePasswordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ChangePasswordViewController: EditProfileButtonTableViewCellDelegate {
    func backScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func changePass() {
        let cellOldPassword = self.tb.cellForRow(at: [0,0]) as? ProfileDetailTableViewCell
        let cellNewPassword = self.tb.cellForRow(at: [0,1]) as? ProfileDetailTableViewCell
        let cellConfirmPassword = self.tb.cellForRow(at: [0,2]) as? ProfileDetailTableViewCell

        if cellNewPassword?.tf.text != cellOldPassword?.tf.text {
            if cellNewPassword?.tf.text == cellConfirmPassword?.tf.text {
                var params = ChangePassword(password: cellOldPassword?.tf.text ?? "", passwordNew: cellNewPassword?.tf.text ?? "", comfirmPassword: cellConfirmPassword?.tf.text ?? "")
                self.VM.ChangePass(params: params)
            } else {
                self.showToast(message: "Mật khẩu mới không trùng khớp với mật khẩu xác nhận", font: .systemFont(ofSize: 12))
            }
        } else {
            self.showToast(message: "Mật khẩu mới không được trùng với mật khẩu cũ", font: .systemFont(ofSize: 12))
        }
        
    }
    
    func callApi() {
        
        
        
        
      
        switch try! Reachability().connection {
          case .wifi:
            changePass()
          case .cellular:
            changePass()
          case .none:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
          case .unavailable:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
        }
        
        

    }
}


extension ChangePasswordViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "EditProfileButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileButtonTableViewCell")
        self.tb.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")


        self.tb.dataSource = self
        self.tb.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        
    }

    // Data binding event observe - communication
    func observeEvent() {
        
        var loader: UIAlertController?
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                print("Data loaded...")
            case .error(let error):
                print(error)
//                let err = error as! DataError
                if (error == DataError.invalidResponse500.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Chưa kết nổi mạng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
                else if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                }
                else  {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 10.0))
                    }
                }
            case .logout:
                // xử lý logout tại đây
                DispatchQueue.main.async {
                    self?.showToast(message: "Đổi mật khẩu thành công", font: .systemFont(ofSize: 12.0))
                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                }
            }
        }
    }

}

