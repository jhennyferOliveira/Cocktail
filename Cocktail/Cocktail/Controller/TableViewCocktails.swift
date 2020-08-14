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
    var isFavourited = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarApearence()
        setSearchBar()
        updateRighBarButton(isFavourite: isFavourited)
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
    // MARK: - set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // MARK: - blocks delete action if the user is searching
    override func tableView(_ tableView: UITableView, editingStyleForRowAt
        indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isFiltering {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    // MARK: - swipe to delete
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
    // MARK: - return the number of filtered results to fill the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCocktails.count
        }
        return cocktails.count
    }
    // MARK: - shows the full table view or the search results if user is searching
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
    // MARK: - the heart shape of the button will change to fill
    @objc func heartButtonTapped(button sender: UIBarButtonItem) {
        self.isFavourited = !self.isFavourited
        if self.isFavourited {
            // save with file manager
            self.favourite()
        } else {
            // delete with file manager
            self.unfavourite()
        }
        self.updateRighBarButton(isFavourite: self.isFavourited)
    }
    // MARK: - search for the inserted text and reload tableview data showing the results
    func filterContentForSearchText(_ searchText: String) {
        filteredCocktails = cocktails.filter { cocktail -> Bool in
            return cocktail.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    // MARK: - when user selects a row he will be redirected to another screen
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
        navigationItem.hidesBackButton = false
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
    func updateRighBarButton(isFavourite: Bool) {
        let heartButton = UIButton(type: .custom)
        heartButton.addTarget(self, action: #selector(heartButtonTapped(button:)),
                              for: .touchUpInside)
        if isFavourite {
            heartButton.setImage(UIImage(named: "heartRed"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    }
    func favourite() {
        //save with file manager
    }
    func unfavourite() {
        //delete with file manager
    }
}
