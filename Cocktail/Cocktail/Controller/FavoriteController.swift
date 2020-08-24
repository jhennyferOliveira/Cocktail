//
//  FavoriteController.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 15/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class FavoriteController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarApearence()
        setSearchBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        recipes = recipeRepository.readAllItems()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCocktails: [RecipeM] = []
    let cellIdentifier = "favoriteCell"
    let imageLoader = ImageLoader()
    let apiDataHandler = APIDataHandler()
    private var recipeRepository: RecipeRepository {
        RecipeRepository()
    }
    var recipes: [RecipeM] = []
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
            recipeRepository.delete(id: recipes[indexPath.row].identifier)
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    // MARK: - return the number of filtered results to fill the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCocktails.count
        }
        return recipes.count
    }
    // MARK: - shows the full table view or the search results if user is searching
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cellUnwrapped = cell as? CellFavorite {
            var cocktail: RecipeM
            if isFiltering {
                cocktail = filteredCocktails[indexPath.row]
            } else {
                cocktail = recipes[indexPath.row]
            }
            imageLoader.obtainImageWithPath(imagePath: cocktail.image) { (image) in
                               cellUnwrapped.cocktailImage.image = image
                         }
            cellUnwrapped.cocktailName.text = cocktail.title
        }
        return cell
    }
    // MARK: - search for the inserted text and reload tableview data showing the results
    func filterContentForSearchText(_ searchText: String) {
        filteredCocktails = recipes.filter { cocktail -> Bool in
            return cocktail.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    // MARK: - when user selects a row he will be redirected to another screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "RecipeView", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "RecipeView") as? RecipeController
        let selectedRecipe = recipes[indexPath.row]
        next?.drinkUUID = selectedRecipe.identifier
        next?.previous = .favorites
        if let next = next {
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
}
extension FavoriteController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
private extension FavoriteController {
    private func navBarApearence() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationItem.title = "My Favorites"
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
