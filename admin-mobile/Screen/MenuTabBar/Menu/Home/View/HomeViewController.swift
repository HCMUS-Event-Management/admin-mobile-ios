//
//  HomeViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit
import RealmSwift
class HomeViewController: UIViewController {

    @IBOutlet weak var cl: UICollectionView!
    let refreshControl = UIRefreshControl()

    private var VM = HomeViewModel()
    private var isCollectionViewInteractionEnabled = true
    private var clickProcessing = false
    private var titleSection = ["Sự kiện đang diễn ra 🔥","Sự kiện được duyệt của bạn 🔔"]
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        VM.getListEventForHome()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       configNaviBar()
    }
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        label.text = "Xin Chào,\n"
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textAlignment = .center
        label.textColor = .gray
        
        let txtFullname = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        txtFullname.text = ""
        txtFullname.font = UIFont(name: "Helvetica Bold", size: 18)
        
        txtFullname.textAlignment = .center
        
        
        if let userInfo = Contanst.userdefault.object(forKey: "userInfo") as? Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(GetUserInfor.self, from: userInfo) {
                txtFullname.text = savedUser.fullName ?? ""
            }
        }
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: label),UIBarButtonItem(customView: txtFullname)]

    }
    
    func changeDetailEvent(indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.VM.goingOnEvent.count != 0 {
                Contanst.userdefault.set(VM.goingOnEvent[indexPath.row].id, forKey: "eventIdDetail")
                changeScreen(modelType: DetailEventViewController.self, id: "DetailEventViewController")
            }
        } else {
            if self.VM.isMyEvent.count != 0 {
                Contanst.userdefault.set(VM.isMyEvent[indexPath.row].id, forKey: "eventIdDetail")
                changeScreen(modelType: DetailEventViewController.self, id: "DetailEventViewController")
            }
        }
    }

}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if self.VM.goingOnEvent.count == 0 {
                if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NoItemCollectionViewCell", for: indexPath) as? NoItemCollectionViewCell {
                    cell.tilte.text = "Không có sự kiện"
                   return cell
                }
            } else {
                let eventGoingOnEvent = self.VM.goingOnEvent[indexPath.row]
                if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                    cell.eventName.text = eventGoingOnEvent.title
                    cell.owner.text = "Bởi \(eventGoingOnEvent.organizationName)"
                    if eventGoingOnEvent.type == "PAID" {
                        cell.paidName.text = "Có Phí"
                        cell.paidView.backgroundColor = UIColor(red: 149/255, green: 210/255, blue: 144/255, alpha: 0.75)

                    } else {
                        cell.paidName.text = "Miễn Phí"
                        cell.paidView.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.5)
                    }
                    if #available(iOS 15.0, *) {
                        cell.timeStart.text = eventGoingOnEvent.startAt?.formatted(date: .abbreviated, time: .omitted)
                    } else {
                        let newDateFormatter = DateFormatter()
                        newDateFormatter.dateStyle = .short
                        newDateFormatter.timeStyle = .none
                        let formattedDate = newDateFormatter.string(from: eventGoingOnEvent.startAt ?? Date())
                        cell.timeStart.text = formattedDate
                        
                    }
                    cell.locationName.text = eventGoingOnEvent.location?.name
                    
                    cell.imgAvatar.kf.setImage(with: URL(string: self.VM.goingOnEvent[indexPath.row].image))
                    
                    cell.callback = {
                        guard self.isCollectionViewInteractionEnabled, !self.clickProcessing else {
                            return
                        }
                                    
                        self.clickProcessing = true
                                    
                        // Perform your desired action for the selected item
                        self.changeDetailEvent(indexPath: indexPath)
                                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.clickProcessing = false
                        }
                    }
                    cell.layer.cornerRadius = 10
                    cell.layer.masksToBounds = true
                    
                    return cell
                }
            }
        } else if indexPath.section == 1{
            if self.VM.isMyEvent.count == 0 {
                if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NoItemCollectionViewCell", for: indexPath) as? NoItemCollectionViewCell {
                    cell.tilte.text = "Không có sự kiện"
                   return cell
                }
            } else {
                let eventIsCommingEvent = self.VM.isMyEvent[indexPath.row]
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                    
                    cell.eventName.text = eventIsCommingEvent.title
                    cell.owner.text = "Bởi \(eventIsCommingEvent.organizationName)"
                    if eventIsCommingEvent.type == "PAID" {
                        cell.paidName.text = "Có Phí"
                        cell.paidView.backgroundColor = UIColor(red: 149/255, green: 210/255, blue: 144/255, alpha: 0.75)

                    } else {
                        cell.paidName.text = "Miễn Phí"
                        cell.paidView.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.5)
                    }
                    if #available(iOS 15.0, *) {
                        cell.timeStart.text = eventIsCommingEvent.startAt?.formatted(date: .abbreviated, time: .omitted)
                    } else {
                        let newDateFormatter = DateFormatter()
                        newDateFormatter.dateStyle = .short
                        newDateFormatter.timeStyle = .none
                        let formattedDate = newDateFormatter.string(from: eventIsCommingEvent.startAt ?? Date())
                        cell.timeStart.text = formattedDate
                        
                    }
                    cell.locationName.text = eventIsCommingEvent.location?.name
                    cell.imgAvatar.kf.setImage(with: URL(string: self.VM.isMyEvent[indexPath.row].image))
                    
                    
                    cell.callback = {
                        guard self.isCollectionViewInteractionEnabled, !self.clickProcessing else {
                            return
                        }
                                    
                        self.clickProcessing = true
                                    
                        // Perform your desired action for the selected item
                        self.changeDetailEvent(indexPath: indexPath)
                                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.clickProcessing = false
                        }
                    }
                    
                    cell.layer.cornerRadius = 10
                    cell.layer.masksToBounds = true
                    
                    return cell
                }
            }
        }
        
        return UICollectionViewCell()

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0) {
            if self.VM.goingOnEvent.count == 0 {
                return 1
            }
            return self.VM.goingOnEvent.count
        } else {
            if self.VM.isMyEvent.count == 0 {
                return 1
            }
            return self.VM.isMyEvent.count
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if VM.goingOnEvent.count == 0 {
                return CGSize(width: collectionView.frame.width, height: 140)
            } else {
                return CGSize(width: collectionView.frame.width/2 - 10, height: 220)
            }
        } else if indexPath.section == 1 {
            if VM.isMyEvent.count == 0 {
                return CGSize(width: collectionView.frame.width, height: 140)
            } else {
                return CGSize(width: collectionView.frame.width/2 - 10, height: 220)
            }
        }
        return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionReusableView", for: indexPath) as? HomeCollectionReusableView{
            sectionHeader.tilte.text = titleSection[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isCollectionViewInteractionEnabled, !clickProcessing else {
                        return
                    }
                    
                    clickProcessing = true
                    
                    // Perform your desired action for the selected item
                    changeDetailEvent(indexPath: indexPath)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.clickProcessing = false
                    }
            
            collectionView.deselectItem(at: indexPath, animated: true)
        }
}


extension HomeViewController {
    @objc private func refreshData(_ sender: Any) {
        self.VM.fetchListGoingOn()
        self.VM.fetchListIsEvent()
    }
    func configuration() {
        self.cl.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
        self.cl.register(UINib(nibName: "NoItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoItemCollectionViewCell")

        self.cl.dataSource = self
        self.cl.delegate = self
        
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.cl.refreshControl = refreshControl
        
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
                    self?.cl.reloadData()
                    self?.refreshControl.endRefreshing()
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
