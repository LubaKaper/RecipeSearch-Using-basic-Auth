//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by Liubov Kaper  on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    func configureCell(for recipe: Recipe) {
        recipeLabel.text = recipe.label
        //set image for recipeto break strong reference cycles
        // use a capture list e.g [weak self] or [unowned self]
        recipeImageView.getImage(with: recipe.image) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.recipeImageView.image = UIImage(systemName: "excaimationmark.triangle")
                }
            case .success(let image):
                // what thread are we on? global() background
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                }
            }
        }
//
    }
}
