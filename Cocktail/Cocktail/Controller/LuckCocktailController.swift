//
//  LuckCocktailController.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 15/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import UIKit

class LuckCocktailController: UIViewController {
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var image: UIImageView!
    let tapRec = UITapGestureRecognizer()
    var recipe: Recipe?
    var completeRecipe: RecipeM  = RecipeM()
    var apiDataHandler = APIDataHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRec.addTarget(self, action: #selector(tappedImage))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapRec)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.title = "Luck Cocktail"
    }
    @objc func tappedImage() {
        getRandomCocktail()
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
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
extension LuckCocktailController {
    func getRandomCocktail() {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
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
    
}
