//
//  CategoryCell.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 13/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var cardLabel: UILabel!
      @IBOutlet weak var cardImage: UIImageView!
      static func identifier() -> String {
          return "CategoryCell"
      }
      func config(label: String, image: UIImage) {
          cardLabel.text = label
          cardImage.image = image
      }
      static func nib() -> UINib {
          return UINib(nibName: CategoryCell.identifier(), bundle: nil)
      }
      override func awakeFromNib() {
          super.awakeFromNib()
          self.layer.cornerRadius = 12
      }

}
