//
//  ProfileDetailViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/02/2023.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    @IBOutlet weak var btnDeleteaccount: UIButton!
    @IBOutlet weak var btnChangepassword: UIButton!
    @IBOutlet weak var tb: UITableView!
    var dataLabel = ["Email:","Số điện thoại:","Địa chỉ:","Ngày sinh:","Chứng minh nhân dân:","Giới tính:"]
    
    
    
    var VM = ProfileViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnChangepassword.addTarget(self, action: #selector(changeChangePasswordController), for: .touchUpInside)

        configuration()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.VM.getUserDetailFromLocalDB()

        
        tabBarController?.tabBar.isHidden = true
        
        configNaviBar()
        
        btnDeleteaccount.layer.cornerRadius = 10
        btnDeleteaccount.layer.masksToBounds = true
        
        btnChangepassword.layer.cornerRadius = 10
        btnChangepassword.layer.masksToBounds = true

    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(changeEditProfileController))
        
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Thông tin"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backScreen)),UIBarButtonItem(customView: title)]
    }
    
    @objc func backScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func changeChangePasswordController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeEditProfileController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
 


}


extension ProfileDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell {
                if let url = URL(string: (VM.userInfoDetail?.avatar) ?? "") {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            cell.imgAvatar.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                } else {
                    cell.imgAvatar.image = UIImage(named: "avatar test")
                }
                cell.txtName.text = VM.userInfoDetail?.fullName
                return cell
            }
        } else if (indexPath.row == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.email
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        } else if (indexPath.row == 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.phone
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        } else if (indexPath.row == 3) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.address
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        } else if (indexPath.row == 4) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                let date = dateFormatter.date(from: VM.userInfoDetail?.birthday ?? "1970-01-01T00:00:00.000Z")

                if #available(iOS 15.0, *) {
                    cell.tf.text = date?.formatted(date: .abbreviated, time: .omitted)
                } else {
                    // Xử lý cho phiên bản iOS dưới 15.0
                    // Ví dụ: Hiển thị ngày giờ theo định dạng tùy chỉnh
                    let customDateFormatter = DateFormatter()
                    customDateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString = customDateFormatter.string(from: date ?? Date())
                    cell.tf.text = dateString
                }
                
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        } else if (indexPath.row == 5) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.identityCard
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        } else if (indexPath.row == 6) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.gender
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        }
        
        return UITableViewCell()

    }
    
    
    
}


extension ProfileDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.row == 0) {
            return tableView.layer.frame.height/4
        }
        return tableView.layer.frame.height/8
    }
    
}


extension ProfileDetailViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
        self.tb.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")

        self.tb.dataSource = self
        self.tb.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
//        self.VM.fetchUserDetail()
    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?

        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading: break
            case .stopLoading: break
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                }
            case .error(let error):
                print(error)
//                let err = error as! DataError
//                if (err == DataError.invalidResponse401) {
//                    DispatchQueue.main.async {
//                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
//                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
//                    }
//                }
            case .logout: break
            case .updateProfile: break
                //reloadtb
            }
        }
    }

}
