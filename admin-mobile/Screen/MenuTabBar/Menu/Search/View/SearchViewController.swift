//
//  SearchViewController.swift
//  AppStoreSearch
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Marcos Griselli. All rights reserved.
//

import UIKit
import Reachability

class SearchViewController: UITableViewController {

    var VM = SearchViewModel()

    private let trendingDataSourceDelegate = TrendingDataSourceDelegate()
    private var searchController: UISearchController!
    private let resultsContainerViewController =
        ResultsContainerViewController()
    private var searchType: SearchType = .final
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = trendingDataSourceDelegate
        tableView.delegate = trendingDataSourceDelegate
        trendingDataSourceDelegate.didSelect = search
        /// Really important. Removing this avoids the TableView
        /// from scrolling past the navigation bar so it bounces
        /// and produces a strange bug.
        extendedLayoutIncludesOpaqueBars = true
        setSearchController()
        navigationController?.navigationBar.setShadow(hidden: true)
        resultsContainerViewController.callback = {
            self.changeScreen(modelType: DetailEventViewController.self, id: "DetailEventViewController")
        }
    }
    
    private func setSearchController() {
        searchController = UISearchController(
            searchResultsController: resultsContainerViewController
        )
        resultsContainerViewController.didSelect = search
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Tìm"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    

    private func search(term: String) {
        searchController.searchBar.text = term
        searchType = .final
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
        navigationController?.navigationBar.setShadow(hidden: false)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchType = searchText.isEmpty ? .final : .partial
        navigationController?.navigationBar
            .setShadow(hidden: searchText.isEmpty)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.navigationBar.setShadow(hidden: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        search(term: text)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
                return
        }
        resultsContainerViewController.handle(
            term: text,
            searchType: searchType
        )
    }
}
