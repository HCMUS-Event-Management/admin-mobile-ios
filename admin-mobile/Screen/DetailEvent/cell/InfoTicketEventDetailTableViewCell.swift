//
//  InfoTicketEventDetailTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/05/2023.
//

import UIKit
import RealmSwift
class InfoTicketEventDetailTableViewCell: UITableViewCell {
    private var data = List<ProposalSessionTicketsObject>()
    private var startFSession = ""
    private var startESession = ""
    let dateFormatter = DateFormatter()
    @IBOutlet weak var StartEndSession: UILabel!
    @IBOutlet weak var startFirstSession: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tb: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10
        self.tb.delegate = self
        self.tb.dataSource = self
        self.tb.register(UINib(nibName: "EventSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "EventSessionTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func receiveData(data: List<ProposalSessionTicketsObject>, startFSession: String, startESession: String) {
        self.data = data
        self.startFSession = startFSession
        self.startESession = startESession
        
        

        let start = dateFormatter.date(from: self.startFSession ?? "1970-01-01T00:00:00.000Z")
        let end = dateFormatter.date(from: self.startESession ?? "1970-01-01T00:00:00.000Z")
        if #available(iOS 15.0, *) {
            self.startFirstSession.text = start?.formatted(date: .numeric, time: .shortened)
            self.StartEndSession.text = end?.formatted(date: .numeric, time: .shortened)
        } else {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateStyle = .short
            newDateFormatter.timeStyle = .short

                if let startDate = start {
                    self.startFirstSession.text = newDateFormatter.string(from: startDate)
                } else {
                    self.startFirstSession.text = "Unknown"
                }
                
                if let endDate = end {
                    self.StartEndSession.text = newDateFormatter.string(from: endDate)
                } else {
                    self.StartEndSession.text = "Unknown"
                }
        }
        
        
        


        self.tb.reloadData()
        
    }
    
}

extension InfoTicketEventDetailTableViewCell:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventSessionTableViewCell", for: indexPath) as? EventSessionTableViewCell
        {
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = "VND"
            if #available(iOS 15.0, *) {
                cell.price.text = "\(data[indexPath.section].price.formatted(.currency(code: "VND")))"
            } else {
                let priceFormatted = currencyFormatter.string(from: NSNumber(value: data[indexPath.section].price))
                cell.price.text = priceFormatted
            }
            
            cell.title.text = data[indexPath.section].ticketTitle
            var startSell = self.dateFormatter.date(from: data[indexPath.section].startTimeForSell)
            var endSell = self.dateFormatter.date(from: data[indexPath.section].endTimeForSell)

            if #available(iOS 15.0, *) {
                cell.start.text = startSell?.formatted(date: .numeric, time: .shortened)
                cell.end.text = endSell?.formatted(date: .numeric, time: .shortened)
            } else {
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateStyle = .short
                newDateFormatter.timeStyle = .short

                    if let startDate = startSell {
                        cell.start.text = newDateFormatter.string(from: startDate)
                    } else {
                        cell.start.text = "Unknown"
                    }
                    
                    if let endDate = endSell {
                        cell.end.text = newDateFormatter.string(from: endDate)
                    } else {
                        cell.end.text = "Unknown"
                    }
            }
            


            return cell
        }
        return UITableViewCell()
    }

}
