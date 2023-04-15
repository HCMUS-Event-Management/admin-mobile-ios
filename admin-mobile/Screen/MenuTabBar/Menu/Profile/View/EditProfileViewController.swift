//
//  EditProfileViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit
import DropDown
class EditProfileViewController: UIViewController, EditProfileButtonTableViewCellDelegate {
    func backScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callApi() {
        let fullname = tb.cellForRow(at: [0,1]) as? ProfileDetailTableViewCell
        let phone = tb.cellForRow(at: [0,2]) as? ProfileDetailTableViewCell
        let address = tb.cellForRow(at: [0,3]) as? ProfileDetailTableViewCell
        let dot = tb.cellForRow(at: [0,4]) as? ProfileDetailTableViewCell
        let idCard = tb.cellForRow(at: [0,5]) as? ProfileDetailTableViewCell
        let gender = tb.cellForRow(at: [0,6]) as? ProfileDetailTableViewCell
        
        if (fullname?.tf.text == VM.userInfoDetail?.fullName && phone?.tf.text == VM.userInfoDetail?.phone && dot?.tf.text == VM.userInfoDetail?.birthday && idCard?.tf.text == VM.userInfoDetail?.identityCard && gender?.tf.text == VM.userInfoDetail?.gender && address?.tf.text == VM.userInfoDetail?.address){
            showToast(message: "Không có gì thay đổi", font: .systemFont(ofSize: 12))
        } else {
            let infoProfile = UpdateProfile(fullName: fullname?.tf.text ?? "", phone: phone?.tf.text ?? "", birthday: VM.userInfoDetail?.birthday ?? "", identityCard: idCard?.tf.text ?? "", gender: gender?.tf.text ?? "", avatar: VM.userInfoDetail?.avatar ?? "", address: address?.tf.text ?? "", isDeleted: false)
            
            VM.updateUserDetail(params: infoProfile)
        }
        
    }
    
    var VM = ProfileViewModel()

    

    var dataLabel = ["Fullname:","Number phone:","Address:","Birthday:","Identity card:","Gender:"]
    var dataPlaceHolder = ["Ex: ngyenvana@gmail.com","Ex: 01234567892","Ex: 123 Võ Văn Kiệt, P6, Quận 5, TP.HCM","Ex: 09/07/2001","Ex: 212950358","Ex: Male"]
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Edit Profile"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
//        VM.userInfoDetail?.birthday = sender.date.formatted('YYYY-MM-DD')
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.string(from: sender.date) + "T00:00:00.000Z"
        
        VM.userInfoDetail?.birthday = date
        tb.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)

    }
  

}


extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as? EditProfileTableViewCell {
                return cell
            }
        } else if(indexPath.row == dataLabel.count + 1){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileButtonTableViewCell", for: indexPath) as? EditProfileButtonTableViewCell {
                cell.delegate = self
                cell.btnSelect.setTitle("Update", for: .normal)

                return cell
            }
        } else if (indexPath.row == 1) {
            print(indexPath)
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.fullName
                return cell
            }
        } else if (indexPath.row == 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.phone
                cell.tf.keyboardType = .numberPad
                return cell
            }
        } else if (indexPath.row == 3) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.address
                return cell
            }
        } else if (indexPath.row == 4) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let date = dateFormatter.date(from:  VM.userInfoDetail?.birthday ?? "1970-01-01T00:00:00.000Z")

                
                cell.tf.text = date?.formatted(date: .abbreviated, time: .omitted)
                
                // date Picker
                let datePicker = UIDatePicker()
                datePicker.setDate(date ?? Date(), animated: true)
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
                datePicker.preferredDatePickerStyle = .inline
                cell.tf.inputView = datePicker
                
                return cell
            }
        } else if (indexPath.row == 5) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.identityCard
                cell.tf.keyboardType = .numberPad
                return cell
            }
        } else if (indexPath.row == 6) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
            
                // dropDown
                let countryValuesArray = ["MALE", "FEMALE"]

                let myDropDown = DropDown()
                myDropDown.anchorView = cell.mainView
                myDropDown.dataSource = countryValuesArray
                myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
                myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
                myDropDown.direction = .bottom
                
                myDropDown.selectionAction = { (index: Int, item: String) in
                    self.VM.userInfoDetail?.gender = countryValuesArray[index]
//                    self.tb.reloadData()
                    self.tb.reloadRows(at: [indexPath], with: .none)

                }
                
                cell.callback = {
                    cell.tf.endEditing(true)
                    myDropDown.show()
                }
                
                //default
                cell.tf.text = VM.userInfoDetail?.gender
   
                return cell
            }
        }
        
        
        
        return UITableViewCell()

    }
    
    
    
}


extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.row == 0) {
            return tableView.layer.frame.height/5
        }
        return tableView.layer.frame.height/9
    }
    
}

extension EditProfileViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileTableViewCell")
        self.tb.register(UINib(nibName: "EditProfileButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileButtonTableViewCell")
        self.tb.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")


        self.tb.dataSource = self
        self.tb.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
//        self.VM.updateUserDetail()
        self.VM.fetchUserDetail()
    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                DispatchQueue.main.async {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .error(let error):                
//                let err = error as! DataError
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 11.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 11.0))
                    }
                }
            case .logout: break
            case .updateProfile:
                self?.VM.fetchUserDetail()
                //reloadtb
            }
        }
    }

}

