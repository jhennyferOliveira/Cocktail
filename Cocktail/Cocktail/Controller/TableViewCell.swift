//
//  TableViewCell.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 13/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var cocktailName: UILabel!
    override func awakeFromNib() {
        self.cocktailImage.layer.cornerRadius = cocktailImage.frame.width/2
    }
}
