//
//  RepositoryRecipe.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 20/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
// MARK: - Repository Methods are used indirectly from Plant Repository
class RecipeRepository: RepositoryMethods {
    typealias Item = RecipeM
    var items: [RecipeM] = []
}
