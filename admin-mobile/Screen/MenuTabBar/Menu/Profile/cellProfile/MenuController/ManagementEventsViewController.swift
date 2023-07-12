//
//  FavoriteEventsViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class ManagementEventsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var clEvent: UICollectionView!
    @IBOutlet weak var clType: UICollectionView!
    
    @IBOutlet weak var countType: UILabel!
    private var VM = EventsViewModel()

    var typeEvents = ["Sự kiện đang chờ duyệt","Sự kiện đã được duyệt","Sự kiện đã huỷ","Sự kiện bị từ chối","Sự kiện đã thu hồi","Sự kiện cần chỉnh sửa"]
    var typeEventsSearch = ["PENDING_APPROVAL","APPROVED","REJECTED","CANCELED","RECALLED","SENT_BACK"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        VM.fetchCategoryAll()

        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false

       configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Quản lý sự kiện"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backScreen)),UIBarButtonItem(customView: title)]
    }
    
    @objc func backScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    func changeDetailEvent(indexPath: IndexPath) {
        if self.VM.events.count != 0 {
            Contanst.userdefault.set(VM.events[indexPath.row].id, forKey: "eventIdDetail")
            changeScreen(modelType: DetailEventViewController.self, id: "DetailEventViewController")
        }
    }
    

}

extension ManagementEventsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clType {
//            return VM.catagorys.count
            return typeEvents.count
        } else if collectionView == self.clEvent {
            if VM.events.count == 0 {
                return 1
            }
            return VM.events.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.clType {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as? TypeCollectionViewCell {
                cell.layer.cornerRadius = 25
                cell.layer.masksToBounds = true
                cell.category.text = typeEvents[indexPath.row]
                cell.callback = {
//                    self.countType.text = "\(self.VM.catagorys[indexPath.row].name)"
                    self.countType.text = "\(self.typeEvents[indexPath.row])"

                }
                return cell
            }
            
        }else if collectionView == self.clEvent {
            
            if self.VM.events.count == 0 {
                if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NoItemCollectionViewCell", for: indexPath) as? NoItemCollectionViewCell {
                    cell.tilte.text = "Không có sự kiện nào"
                   return cell
                }
            } else {
                let event = self.VM.events[indexPath.row]

                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                    
                    cell.eventName.text = event.title
                    cell.owner.text = "Bởi \(event.user!.fullName)"
                    if event.type == "PAID" {
                        cell.paidName.text = "Có Phí"
                    } else {
                        cell.paidName.text = "Miễn Phí"
                    }
                    
                    if #available(iOS 15.0, *) {
                        cell.timeStart.text = event.startAt?.formatted(date: .abbreviated, time: .omitted)
                    } else {
                        let newDateFormatter = DateFormatter()
                        newDateFormatter.dateStyle = .short
                        newDateFormatter.timeStyle = .none
                        let formattedDate = newDateFormatter.string(from: event.startAt ?? Date())
                        cell.timeStart.text = formattedDate
                        
                    }
                    cell.locationName.text = event.location?.name
                    cell.imgAvatar.kf.setImage(with: URL(string: self.VM.events[indexPath.row].image))
                    
                    
                    cell.callback = {
                        self.changeDetailEvent(indexPath: indexPath)
                    }
                    
                    cell.layer.cornerRadius = 10
                    cell.layer.masksToBounds = true
                    
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }
    

    
}


extension ManagementEventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.clEvent {
            if VM.events.count == 0 {
                return CGSize(width: collectionView.frame.width, height: 50)
            }
            return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

        } else if collectionView == self.clType {
            return CGSize(width: collectionView.frame.width/2, height: 50)
        }
        return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clType {
            VM.fetchListEventOfManagerUser(fullTextSearch: typeEventsSearch[indexPath.row])
        } else if collectionView == self.clEvent {
            changeDetailEvent(indexPath: indexPath)
        }
    }
    
    
}

extension ManagementEventsViewController {

    func configuration() {
        self.clEvent.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
        self.clType.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TypeCollectionViewCell")
        self.clEvent.register(UINib(nibName: "NoItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoItemCollectionViewCell")

        self.clType.dataSource = self
        self.clType.delegate = self

        self.clEvent.dataSource = self
        self.clEvent.delegate = self
        
        self.clType.contentInsetAdjustmentBehavior = .never;
    
        
        let ind =  IndexPath(item: 1, section: 0)
        self.clType.selectItem(at:ind, animated: false, scrollPosition: [])
        self.collectionView((self.clType)!, didSelectItemAt:ind)
        self.clEvent.reloadData()
        
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
            case .categoryLoaded:
                DispatchQueue.main.async {
                    self?.clType.reloadData()
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
//                    self?.clType.reloadData()
                    self?.clEvent.reloadData()
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
    


