//
//  APIHandller.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 17/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
class APIDataHandler {
    func orderDictionaryValues(dict: [String: String]) -> [String] {
        let sortedKeys = Array(dict.keys).sorted()
        var values: [String] = []
        for item in sortedKeys {
            for (key, value) in dict {
                if item == key {
                    values.append(value)
                }
            }
        }
        return values
    }
    // merge two strings
    func mergeIngredientsAndMeasures(ingredients: [String], measures: [String]) -> String {
        var finalIngredients = ""
        var contador = 0
        if ingredients.count == measures.count {
            contador = ingredients.count
        } else if ingredients.count < measures.count {
            contador = ingredients.count
        } else {
            contador = measures.count
        }
        if contador <= 0 {
            return ""
        } else {
            for ident in 0...contador - 1 {
                finalIngredients += measures[ident] + " " + ingredients[ident]
                if ident < contador - 1 {
                    finalIngredients += "\n"
                }
            }
            return finalIngredients
        }
        
    }
    // get only the important data that come from json
    func filterItemsFromRecipe(recipe: Recipe) -> RecipeM {
        let completeRecipe = RecipeM()
        var ingredients: [String: String] = [:]
        var measures: [String: String] = [:]
        for item in recipe.drinks {
            for (key, value) in item {
                if let value = value {
                    let searchString1 = "strIngredient"
                    let searchString2 = "strMeasure"
                    if key.hasPrefix(searchString1) {
                        ingredients[key] = value
                    } else if key.hasPrefix(searchString2) {
                        measures[key] = value
                    } else if key == "strGlass" {
                        completeRecipe.glass = value
                    } else if key == "strInstructions" {
                        completeRecipe.directions = value
                    } else if key == "strDrinkThumb" {
                        completeRecipe.image = value
                    } else if key == "strDrink" {
                        completeRecipe.title = value
                    }
                }
            }
        }
        completeRecipe.ingredients = orderDictionaryValues(dict: ingredients)
        completeRecipe.measures = orderDictionaryValues(dict: measures)
        return completeRecipe
    }
}
