//
//  DrinkM.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 17/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation

struct Drinks: Codable {
    let drinks: [DrinkM]
}
struct DrinkM: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
    init(strDrink: String, strDrinkThumb: String, idDrink: String) {
        self.strDrinkThumb = strDrinkThumb
        self.strDrink = strDrink
        self.idDrink = idDrink
    }
}
