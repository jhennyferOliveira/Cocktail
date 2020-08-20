//
//  RecipeM.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 17/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation

class RecipeM: Codable {
    var image: String = ""
    var glass: String = ""
    var title: String = ""
    var ingredients: [String] = []
    var measures: [String] = []
    var directions: String = ""
    var category: String = ""
    let idDrink: String = ""
    init(image: String, title: String, ingredients: [String], directions: String,
         category: String, idDrink: String, measures: [String], glass: String) {
        self.image = image
        self.title = title
        self.ingredients = ingredients
        self.directions = directions
        self.category = category
        self.measures = measures
        self.glass = glass
    }
    init() {}
}

struct Recipe: Codable {
       let drinks: [[String: String?]]
   }
