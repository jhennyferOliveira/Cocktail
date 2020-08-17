//
//  LuckCocktailController.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 15/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import UIKit

class LuckCocktailController: UIViewController {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var image: UIImageView!
    let tapRec = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRec.addTarget(self, action: #selector(tappedImage))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapRec)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8289034963, blue: 0.4533876181, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.title = "Luck Cocktail"

        // Do any additional setup after loading the view.
    }
    @objc func tappedImage() {
        let storyboard = UIStoryboard(name: "RecipeView", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "RecipeView") as UIViewController
        self.navigationController?.pushViewController(next, animated: true)
        print("image tapped")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
