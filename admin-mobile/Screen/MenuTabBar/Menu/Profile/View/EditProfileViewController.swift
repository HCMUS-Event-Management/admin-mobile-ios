//
//  EditProfileViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit
import DropDown
import Reachability
class EditProfileViewController: UIViewController, EditProfileButtonTableViewCellDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func backScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProfile() {
        let fullname = tb.cellForRow(at: [0,1]) as? ProfileDetailTableViewCell
        let phone = tb.cellForRow(at: [0,2]) as? ProfileDetailTableViewCell
        let address = tb.cellForRow(at: [0,3]) as? ProfileDetailTableViewCell
        let dot = tb.cellForRow(at: [0,4]) as? ProfileDetailTableViewCell
        let idCard = tb.cellForRow(at: [0,5]) as? ProfileDetailTableViewCell
        let gender = tb.cellForRow(at: [0,6]) as? ProfileDetailTableViewCell
        convertImageUrlToUploadDto(urlString: VM.userInfoDetail?.avatar ?? "https://nestjs-user-auth-service-bucket.s3.ap-southeast-1.amazonaws.com/user_id_3/avatar/vT6eDoY3T1umU3rTtkoiV5QTve0yTBQTx5R3XLjRlr5tGNwwB1.%28format_file%3A%20jpeg") { (uploadDto) in
            if let uploadDto = uploadDto {
                
                // ngày giờ
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                let date = dateFormatter.date(from:  self.VM.userInfoDetail?.birthday ?? "1970-01-01T00:00:00.000Z")

                var formattedDate: String?
                if #available(iOS 15.0, *) {
                    formattedDate = date?.formatted(date: .numeric, time: .omitted) ?? ""
                } else {
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateStyle = .short
                    newDateFormatter.timeStyle = .none
                    formattedDate = newDateFormatter.string(from: date ?? Date())
                }

                // so sánh
                DispatchQueue.main.async {
                    if (fullname?.tf.text == self.VM.userInfoDetail?.fullName && phone?.tf.text == self.VM.userInfoDetail?.phone && dot?.tf.text == formattedDate && idCard?.tf.text == self.VM.userInfoDetail?.identityCard && gender?.tf.text == self.VM.userInfoDetail?.gender && address?.tf.text == self.VM.userInfoDetail?.address){
//                        print(fullname?.tf.text, self.VM.userInfoDetail?.fullName , phone?.tf.text ,self.VM.userInfoDetail?.phone ,dot?.tf.text , formattedDate,self.VM.userInfoDetail?.birthday ,idCard?.tf.text, self.VM.userInfoDetail?.identityCard , gender?.tf.text, self.VM.userInfoDetail?.gender, address?.tf.text ,self.VM.userInfoDetail?.address)
                        self.showToast(message: "Không có gì thay đổi", font: .systemFont(ofSize: 12))
                    } else {
                        let infoProfile = UpdateProfile(fullName: fullname?.tf.text ?? "", phone: phone?.tf.text ?? "", birthday: self.birthday ?? "", identityCard: idCard?.tf.text ?? "", gender: gender?.tf.text ?? "",address: address?.tf.text ?? "", image: uploadDto)
                        self.VM.updateUserDetail(params: infoProfile)
                    }
                }
            } else {
                self.showToast(message: "Lỗi trong quá trình update của convert link ảnh sang updaload avatar", font: .systemFont(ofSize: 12))
            }
        }
    }
    
    func callApi() {
        switch try! Reachability().connection {
          case .wifi:
            updateProfile()
          case .cellular:
            updateProfile()
          case .none:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
          case .unavailable:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
        }
    }
    
    var VM = ProfileViewModel()
    var birthday:String?
    var gender:String?

    var imagePicker = UIImagePickerController()

    var dataLabel = ["Họ và tên:","Số điện thoại:","Địa chỉ:","Ngày sinh:","Chứng minh thư:","Giới tính:"]
    var dataPlaceHolder = ["Ex: ngyenvana@gmail.com","Ex: 01234567892","Ex: 123 Võ Văn Kiệt, P6, Quận 5, TP.HCM","Ex: 09/07/2001","Ex: 212950358","Ex: Male"]
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        self.VM.getUserDetailFromLocalDB()
        self.hideKeyboardWhenTappedAround()
        birthday = VM.userInfoDetail?.birthday
        gender = VM.userInfoDetail?.gender
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNaviBar()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            let imageData:Data = image.pngData()!
            switch try! Reachability().connection {
              case .wifi:
                VM.uploadAvatar(imageData: imageData)
              case .cellular:
                VM.uploadAvatar(imageData: imageData)
              case .none:
                showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
              case .unavailable:
                showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
            }
        } else{
            showToast(message: "Lỗi trong upload avatar", font: .systemFont(ofSize: 12))
        }
        
       self.dismiss(animated: true, completion: nil)
      }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Chỉnh sửa"
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
        birthday = date
//        VM.userInfoDetail?.birthday = date
        tb.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)

    }
  
    
    
    func convertImageUrlToUploadDto(urlString: String, completion: @escaping (UploadAvatarDto?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            let base64String = imageData.base64EncodedString()
            
            let pathExtension = url.pathExtension
            
            var uploadDto = UploadAvatarDto(mime: "image/(format_file: \(pathExtension))", data: base64String)
            
            completion(uploadDto)
        }
        
        task.resume()
    }

}


extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as? EditProfileTableViewCell {
                
                if let url = URL(string: (VM.userInfoDetail?.avatar) ?? "") {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            cell.avatar.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                } else {
                    cell.avatar.image = UIImage(named: "avatar test")
                }
                
                
                
                
                cell.callback = {
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
                        self.imagePicker.delegate = self
                        self.imagePicker.sourceType = .savedPhotosAlbum
                        self.imagePicker.allowsEditing = false
            
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
                return cell
            }
        } else if(indexPath.row == dataLabel.count + 1){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileButtonTableViewCell", for: indexPath) as? EditProfileButtonTableViewCell {
                cell.delegate = self
                cell.btnSelect.setTitle("Cập nhật", for: .normal)

                return cell
            }
        } else if (indexPath.row == 1) {
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

                let date = dateFormatter.date(from:  birthday ?? "1970-01-01T00:00:00.000Z")

                var formattedDate: String
                if #available(iOS 15.0, *) {
                    formattedDate = date?.formatted(date: .numeric, time: .omitted) ?? ""
                } else {
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateStyle = .short
                    newDateFormatter.timeStyle = .none
                    formattedDate = newDateFormatter.string(from: date ?? Date())
                }

                cell.tf.text = formattedDate

                
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//                let date = dateFormatter.date(from:  VM.userInfoDetail?.birthday ?? "1970-01-01T00:00:00.000Z")
//
//
//                cell.tf.text = date?.formatted(date: .abbreviated, time: .omitted)
                
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
                    self.gender = countryValuesArray[index]
//                    self.tb.reloadData()
                    self.tb.reloadRows(at: [indexPath], with: .none)

                }
                
                cell.callback = {
                    cell.tf.endEditing(true)
                    myDropDown.show()
                }
                
                //default
                cell.tf.text = self.gender
   
                return cell
            }
        }
        
        
        
        return UITableViewCell()

    }
    
    
    
}


extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.row == 0) {
            return (tableView.layer.frame.height/12) * 3
        }
        return (tableView.layer.frame.height/10)
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
    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    loader = self?.loader()
                }
            case .stopLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.tb.reloadData()
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .error(let error):
//                let err = error as! DataError
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                } else if (error == DataError.invalidResponse500.localizedDescription){
                    DispatchQueue.main.async {
                        self?.showToast(message: "Chưa kết nối mạng Hoặc hình ảnh quá nặng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
            case .logout: break
            case .updateProfile:
                DispatchQueue.main.async {
                    self?.VM.getUserDetailFromSever()
                }
                //reloadtb
//            case .deleteAcc:
//                break
            case .deleteAcc:
                break
            }
        }
    }

}

