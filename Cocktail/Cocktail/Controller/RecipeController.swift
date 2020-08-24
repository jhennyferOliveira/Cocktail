//
//  RecipeController.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 14/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import UIKit

class RecipeController: UIViewController {
    @IBOutlet weak var glassTitle: UILabel!
    @IBOutlet weak var glassText: UILabel! 
    @IBOutlet weak var ingredientTitle: UILabel!
    @IBOutlet weak var directionTitle: UILabel!
    @IBOutlet weak var ingredientText: UILabel!
    @IBOutlet weak var directionText: UILabel!
    @IBOutlet weak var image: UIImageView!
    enum PreviousView {
        case luckCocktail
        case tableView
        case favorites
    }
    var previous = PreviousView.luckCocktail
    var savedRecipe: Recipe?
    var isFavourited = false
    var drinkId = ""
    var drinkUUID = UUID()
    var apiDataHandler = APIDataHandler()
    var completeRecipe = RecipeM()
    let fileHelper = FileHelper()
    var imageHelper = ImageLoader()
    private var recipeRepository: RecipeRepository {
        RecipeRepository()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarApearence()
        updateRighBarButton(isFavourite: isFavourited)
        switch previous {
        case .favorites:
            getFavoriteRecipe()
        case .luckCocktail:
            getRandomCocktail()
        case .tableView:
            getDrink(drinkId: drinkId)
        }
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
}
extension RecipeController {
    private func navBarApearence() {
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationItem.title = "Some Recipe"
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
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
    func updateView(recipe: Recipe) {
        let recipes = recipeRepository.readAllItems()
        completeRecipe = apiDataHandler.filterItemsFromRecipe(recipe: recipe)
        let ingredients = apiDataHandler
            .mergeIngredientsAndMeasures(ingredients: completeRecipe.ingredients,
                                         measures: completeRecipe.measures)
        navigationItem.title = completeRecipe.title
        glassText.text = completeRecipe.glass
        ingredientText.text = ingredients
        directionText.text = completeRecipe.directions
        imageHelper.obtainImageWithPath(imagePath: completeRecipe.image) { (image) in
            self.image.image = image
        }
        isFavourited =  recipes.contains(where: { (recipe) -> Bool in
            if completeRecipe.title == recipe.title {
                return true
            } else {
                return false
            }
        })
    }
    func favourite() {
        //save with file manager
        let newRecipe = recipeRepository.createNewItem()
        newRecipe?.glass = completeRecipe.glass
        newRecipe?.image = completeRecipe.image
        newRecipe?.ingredients = completeRecipe.ingredients
        newRecipe?.measures = completeRecipe.measures
        newRecipe?.title = completeRecipe.title
        newRecipe?.directions = completeRecipe.directions
        recipeRepository.update(item: newRecipe ?? RecipeM())
    }
    func unfavourite() {
        //delete with file manager
        recipeRepository.delete(id: completeRecipe.identifier)
    }
    private func getDrink(drinkId: String) {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + drinkId
        if let url: URL = URL(string: path) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                        DispatchQueue.main.async {
                            self.updateView(recipe: recipe)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    func getRandomCocktail() {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
        if let url: URL = URL(string: path) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                        DispatchQueue.main.async {
                            self.updateView(recipe: recipe)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    func getFavoriteRecipe() {
        guard let recipe = recipeRepository.readItem(id: drinkUUID) else { return }
        let ingredients = apiDataHandler
            .mergeIngredientsAndMeasures(ingredients: recipe.ingredients,
                                         measures: recipe.measures)
        navigationItem.title = recipe.title
        glassText.text = recipe.glass
        ingredientText.text = ingredients
        directionText.text = recipe.directions
        imageHelper.obtainImageWithPath(imagePath: recipe.image) { (image) in
            self.image.image = image
        }
        isFavourited = true
    }
}
