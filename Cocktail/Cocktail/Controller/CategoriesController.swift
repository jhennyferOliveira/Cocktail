//
//  CategoriesController.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 13/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoriesController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCell.nib(), forCellWithReuseIdentifier: CategoryCell.identifier())
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.title = "Categories"
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 8
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier(), for: indexPath)
        if let unwrappedCell = cell as? CategoryCell {
            unwrappedCell.config(label: "categ", image: #imageLiteral(resourceName: "nonAlcoholic"))
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TableViewCocktailsView", bundle: nil)
        let nextStoryboard = storyboard.instantiateViewController(withIdentifier: "TableViewCocktailsView")
        if let nextStoryboardUnwrapped = nextStoryboard as? UITableViewController {
            self.navigationController?.pushViewController(nextStoryboardUnwrapped, animated: true)
        }

    }
}
