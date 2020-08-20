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
    var filteredCocktails: [DrinkM] = []
    let cellIdentifier = "CellIdentifier"
    var cocktails: [DrinkM]?
    var recipe: Recipe?
    var category: String = ""
    var completeRecipe: RecipeM  = RecipeM()
    var apiDataHandler = APIDataHandler()
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
    // MARK: - return the number of filtered results to fill the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCocktails.count
        }
        filterCategories(categoryName: category)
        if let cocktails = cocktails {
            return cocktails.count
        }
        return 0
    }
    // MARK: - shows the full table view or the search results if user is searching
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cellUnwrapped = cell as? TableViewCell {
            var cocktailHelper: DrinkM = DrinkM(strDrink: "someDrink", strDrinkThumb: "12", idDrink: "1")
            if isFiltering {
                cocktailHelper = filteredCocktails[indexPath.row]
            } else {
                if let cocktails = cocktails {
                    cocktailHelper = cocktails[indexPath.row]
                }
            }
            cellUnwrapped.cocktailName.text = cocktailHelper.strDrink
            let url = URL(string: cocktailHelper.strDrinkThumb)
            if let url = url {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    cellUnwrapped.cocktailImage.image = UIImage(data: data)
                }
            }
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
            getDrink(drinkId: selectedCocktail.idDrink)
            let storyboard = UIStoryboard(name: "RecipeView", bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "RecipeView") as? RecipeController
            if let recipe = recipe {
                completeRecipe = apiDataHandler.filterItemsFromRecipe(recipe: recipe)
                let finalIngredients = apiDataHandler.mergeIngredientsAndMeasures(ingredients: completeRecipe.ingredients, measures: completeRecipe.measures)
                next?.ingredientTextInit = finalIngredients
                next?.glassTextInit = completeRecipe.glass
                next?.drinkName = completeRecipe.title
                next?.directionTextInit = completeRecipe.directions
                let url = URL(string: completeRecipe.image)
                if let url = url {
                    let data = try? Data(contentsOf: url)
                    if let data = data {
                        if let myImage = UIImage(data: data) {
                            next?.imageInit = myImage
                        }
                    }
                }
            }
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
    //get drink by id
    private func getDrink(drinkId: String) {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + drinkId
        if let url: URL = URL(string: path) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                        DispatchQueue.main.async {
                            self.recipe = recipe
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    private func filterCategories(categoryName: String) {
        var newCategName = ""
        if categoryName.contains(" ") {
            let categName = categoryName.split(separator: " ")
            newCategName = categName[0] + "_" + categName[1]
        }
        var path = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?"
        if newCategName == "Non_Alcoholic"{
            path +=  "a=" + newCategName
        } else {
            path += "c=" + categoryName
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
