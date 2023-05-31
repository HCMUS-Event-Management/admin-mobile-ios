//
//  SuggestedTermsTableViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class SuggestedTermsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
//        self.tableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
    }
    var searchedTerm = String() {
        didSet {
            currentNames = namesWith(prefix: searchedTerm)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var terms: [Term] = Bundle.main.loadJSONFile(named: "terms")
    private var currentNames = [String]()
    var didSelect: (String) -> Void = { _ in }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if currentNames.count == 0 {
//            return 1
//        } else {
            return currentNames.count
//        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if currentNames.count == 0 {
//            return self.tableView.layer.frame.height
//        } else {
            return self.tableView.layer.frame.height / 15
//        }
    }
    override func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if currentNames.count == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
//            return cell
//        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuggestedTermTableViewCell
            cell.set(term: currentNames[indexPath.row],
                     searchedTerm: searchedTerm)
            return cell
//        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if currentNames.count == 0 {
//            return
//        } else {
            didSelect(currentNames[indexPath.row])
            
//        }
    }
    
    
    
    func namesWith(prefix: String) -> [String] {
        return terms
            .filter { $0.name.hasCaseInsensitivePrefix(prefix) }
//            .sorted { $0.popularity > $1.popularity }
            .map    { $0.name }
    }
}
