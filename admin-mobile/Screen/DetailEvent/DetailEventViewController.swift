//
//  DetailEventViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 15/05/2023.
//

import UIKit
import RealmSwift
class DetailEventViewController: UIViewController {
    private var VM = HomeViewModel()

    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        let eventIdDetail = Contanst.userdefault.integer(forKey: "eventIdDetail")
        VM.fetchDetailEvent(eventIdDetail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Chi tiết"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backScreen)),UIBarButtonItem(customView: title)]
    }
    
    @objc func backScreen() {
        navigationController?.popViewController(animated: true)
    }
}


extension DetailEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let event = VM.detailEvent
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageQRCodeTableViewCell", for: indexPath) as? ImageQRCodeTableViewCell
            {
                cell.imgQR.kf.setImage(with: URL(string: event.image))

                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoEventTableViewCell", for: indexPath) as? InfoEventTableViewCell  {

                cell.eventName.text = event.title
                cell.location.text = event.location?.name
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                let date = dateFormatter.date(from: event.startAt ?? "1970-01-01T00:00:00.000Z")

                let formattedDate: String
                if #available(iOS 15.0, *) {
                    formattedDate = date?.formatted(date: .abbreviated, time: .shortened) ?? ""
                } else {
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateStyle = .short
                    newDateFormatter.timeStyle = .short

                    formattedDate = newDateFormatter.string(from: date ?? Date())
                }

                cell.date.text = formattedDate

               
                cell.organizer.text = event.user?.fullName
                return cell
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell
            {
                cell.txtDescription.text = event.description1.decodeHTML()?.extractTextFromHTML()
                return cell
            }
        } else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTicketEventDetailTableViewCell", for: indexPath) as? InfoTicketEventDetailTableViewCell
            {
                if event.sessions.count == 1 {
                    cell.receiveData(data: event.sessions[0].proposalSessionTickets,startFSession: event.sessions[0].startAt, startESession: event.sessions[0].endAt)
                } else {
                    var data = List<ProposalSessionTicketsObject>()
                    event.sessions.forEach({
                        i in
                        i.proposalSessionTickets.forEach({
                            j in
                            data.append(j)
                        })
                    })
                    
                    cell.receiveData(data: data,startFSession: event.sessions.first?.startAt ?? "1970-01-01T00:00:00.000Z", startESession: event.sessions.last?.endAt ?? "1970-01-01T00:00:00.000Z")
                }
                return cell
            }
        }
        

        return UITableViewCell()
    }
    
    
    
    
}
extension DetailEventViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.layer.frame.height / 3
        } else if indexPath.section == 2 {
            return tableView.layer.frame.height / 5
        } else if indexPath.section == 3 {
            return tableView.layer.frame.height / 1.5
        }
        
        return tableView.layer.frame.height / 2.5
    }
}


extension DetailEventViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "InfoEventTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoEventTableViewCell")
        self.tb.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        self.tb.register(UINib(nibName: "ImageQRCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageQRCodeTableViewCell")
        self.tb.register(UINib(nibName: "InfoTicketEventDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTicketEventDetailTableViewCell")
        
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
                loader = self?.loader()
            case .stopLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

}
