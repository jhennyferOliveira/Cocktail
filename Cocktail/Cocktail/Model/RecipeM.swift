//
//  RecipeM.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 17/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation

class RecipeM: Codable, RepositoryItem {
    var image: String
    var glass: String
    var title: String
    var ingredients: [String] = []
    var measures: [String] = []
    var directions: String
    var category: String
    let idDrink: String
    let identifier: UUID
    required init() {
        self.identifier = UUID()
        self.image = ""
        self.title = ""
        self.ingredients = []
        self.directions = ""
        self.category = ""
        self.measures = []
        self.glass = ""
        self.idDrink = ""
    }
}

struct Recipe: Codable {
    let drinks: [[String: String?]]
}
