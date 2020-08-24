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
        getItemsFromCategory(categoryName: category)
    }
    // MARK: - Table view data source
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCocktails: [DrinkM] = []
    let cellIdentifier = "CellIdentifier"
    var recipe: Recipe?
    var category: String = ""
    var cocktails: [DrinkM]?
    var completeRecipe: RecipeM  = RecipeM()
    var apiDataHandler = APIDataHandler()
    var imageLoader = ImageLoader()
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var recipeRepository: RecipeRepository {
        RecipeRepository()
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    // MARK: - set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // MARK: - return the number of filtered results to fill the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCocktails.count
        }
        if let cocktails = cocktails {
            return cocktails.count
        }
        return 0
    }
    // MARK: - shows the full table view or the search results if user is searching
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cell = cell as? TableViewCell {
            var cocktailHelper: DrinkM = DrinkM(strDrink: "someDrink", strDrinkThumb: "12", idDrink: "1")
            if isFiltering {
                cocktailHelper = filteredCocktails[indexPath.row]
            } else {
                if let cocktails = cocktails {
                    cocktailHelper = cocktails[indexPath.row]
                }
            }
            imageLoader.obtainImageWithPath(imagePath: cocktailHelper.strDrinkThumb) { (image) in
                    cell.cocktailImage.image = image
              }
            cell.cocktailName.text = cocktailHelper.strDrink
        }
        return cell
    }
    // MARK: - search for the inserted text and reload tableview data showing the results
    func filterContentForSearchText(_ searchText: String) {
        if let cocktails = cocktails {
            filteredCocktails = cocktails.filter { cocktail -> Bool in
                return cocktail.strDrink.lowercased().contains(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
    // MARK: - when user selects a row he will be redirected to another screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cocktails = cocktails {
            let selectedCocktail = cocktails[indexPath.row]
            let storyboard = UIStoryboard(name: "RecipeView", bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "RecipeView") as? RecipeController
            next?.drinkId = selectedCocktail.idDrink
            next?.previous = .tableView
            if let next = next {
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
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
        navigationItem.title = category
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
    // to populate the table view
    private func getItemsFromCategory(categoryName: String) {
        var newCategName = ""
        if categoryName.contains(" ") {
            let categName = categoryName.split(separator: " ")
            newCategName = categName[0] + "_" + categName[1]
        } else {
            newCategName = categoryName
        }
        var path = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?"
        if newCategName == "Non_Alcoholic"{
            path +=  "a=" + newCategName
        } else {
            path += "c=" + newCategName
        }
        if let url: URL = URL(string: path) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let drinks = try JSONDecoder().decode(Drinks.self, from: data)
                        DispatchQueue.main.async {
                            self.cocktails = drinks.drinks
                            self.tableView.reloadData()
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
