//
//  DetailRecipeController.swift
//  RecipeSearch
//
//  Created by Liubov Kaper  on 12/15/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class DetailRecipeController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var ingredientTextView: UITextView!
    
    var recipeInfo: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       updateUI()
    }
    
    func updateUI() {
        guard let recipe = recipeInfo else {
            fatalError("check prepere for segue")
        }
        view.backgroundColor = .systemGray2
        ingredientTextView.backgroundColor = .systemGray2
        let allIngs = recipe.ingredientLines.joined(separator: "\n")
        ingredientTextView.text = allIngs
        
        imageView.getImage(with: recipe.image) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(systemName: "excaimationmark.triangle")
                }
            case .success(let image):
                // what thread are we on? global() background
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
   
}
