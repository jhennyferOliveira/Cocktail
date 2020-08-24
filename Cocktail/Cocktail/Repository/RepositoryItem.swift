//
//  RepositoryItem.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 20/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
protocol RepositoryItem: class, Codable {
    var identifier: UUID { get }
    init()
}
