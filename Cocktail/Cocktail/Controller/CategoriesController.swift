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
        navigationController?.navigationBar.prefersLargeTitles = false
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.title = "Categories"
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted
    //  during tracking override func collectionView(_ collectionView:
     UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed
     //for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView,
     shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView,
     canPerformAction action: Selector, forItemAt indexPath: IndexPath,
     withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView,
     performAction action: Selector, forItemAt indexPath: IndexPath,
     withSender sender: Any?) {
    
    }
    */

}
