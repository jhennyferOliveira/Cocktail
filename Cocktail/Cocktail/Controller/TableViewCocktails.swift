//
//  TableViewCocktails.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 13/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class TableViewCocktails: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarApearence()
        setSearchBar()
    }
    // MARK: - Table view data source
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCocktails: [String] = []
    let cellIdentifier = "CellIdentifier"
    var cocktails = ["Apple", "Pineapple", "Orange", "Blackberry", "Banana",
                     "Pear", "Kiwi"]
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    //define the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // blocks delete action if the user is searching
    override func tableView(_ tableView: UITableView, editingStyleForRowAt
        indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isFiltering {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    // swipe to delete
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            cocktails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    // return the number of filtered results to fill the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCocktails.count
        }
        return cocktails.count
    }
    // shows the full table view or the search results if user is searching
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cellUnwrapped = cell as? TableViewCell {
            var cocktail: String
            if isFiltering {
                cocktail = filteredCocktails[indexPath.row]
            } else {
                cocktail = cocktails[indexPath.row]
            }
            cellUnwrapped.cocktailImage.image = #imageLiteral(resourceName: "Cocktail")
            cellUnwrapped.cocktailName.text = cocktail
        }
        return cell
    }
    // when user taps the plus button he will be redirect to another screen
    @objc func heartButtonTapped(button sender: UIBarButtonItem) {
        // add to favorites(persistence) and change the heart to fill
//        if let image = UIImage(named: "heartRed") {
//            sender.setImage(image, for: .selected)
//          }
    }
    // search for the inserted text in the textfield of searchBar and reload tableview data showing the results
    func filterContentForSearchText(_ searchText: String) {
        filteredCocktails = cocktails.filter { cocktail -> Bool in
            return cocktail.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    // when user selects a row he will be redirected to another screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "next", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "nextCont") as UIViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        print("go to information screen")
    }
}

extension TableViewCocktails: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

private extension TableViewCocktails {
    private func navBarApearence() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationItem.title = "Some Category"
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    private func setSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cocktail"
        navigationItem.searchController = searchController
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        UITextField.appearance().backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.1490196078, blue: 0.01960784314, alpha: 0.1193011558)
    }
}
