//
//  RecipeController.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 14/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import UIKit

class RecipeController: UIViewController {
    var isFavourited = false
    @IBOutlet weak var glassTitle: UILabel!
    @IBOutlet weak var glassText: UILabel!
    @IBOutlet weak var ingredientTitle: UILabel!
    @IBOutlet weak var directionTitle: UILabel!
    @IBOutlet weak var ingredientText: UILabel!
    @IBOutlet weak var directionText: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarApearence()
        updateRighBarButton(isFavourite: isFavourited)
        // Do any additional setup after loading the view.
    }
    // MARK: - the heart shape of the button will change to fill
    @objc func heartButtonTapped(button sender: UIBarButtonItem) {
        self.isFavourited = !self.isFavourited
        if self.isFavourited {
            // save with file manager
            self.favourite()
        } else {
            // delete with file manager
            self.unfavourite()
        }
        self.updateRighBarButton(isFavourite: self.isFavourited)
    }

}

extension RecipeController {
    private func navBarApearence() {
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationItem.title = "Some Recipe"
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    func updateRighBarButton(isFavourite: Bool) {
        let heartButton = UIButton(type: .custom)
        heartButton.addTarget(self, action: #selector(heartButtonTapped(button:)),
                              for: .touchUpInside)
        if isFavourite {
            heartButton.setImage(UIImage(named: "heartRed"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    }
    func favourite() {
        //save with file manager
    }
    func unfavourite() {
        //delete with file manager
    }
}
