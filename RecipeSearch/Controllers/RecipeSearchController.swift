//
//  RecipeSearchController.swift
//  RecipeSearch
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {
    //TODO: we need a table view
    // TODO: we need a recipes array
    // TODO: on recipe array have a didSet{} to update the table view
    //TODO: in cellForRow show the recipe's label
    //TODO: RecipeSearchAPI.fetchRecipes("christmas cookies") {...} accessing data to populate recipes array e.g "christmas cookies"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var recipes = [Recipe]() {
        didSet { // property observer that will change the value of variable if it is called
            // doing DispatchQueue her because data is coming not from local JSON file, but from url!!!!!!!!!!!!!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchRecipes(searchQuary: "sushi")
        searchBar.delegate = self
        tableView.delegate = self
        navigationItem.title = "Recipe Search"
    }
    
    // this function is instead of loadData() func
    func searchRecipes(searchQuary: String) {
        RecipeSearchAPIClient.fetchRecipe(for: searchQuary, completion:  { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("error: \(appError)")
                // TODO: alert controller
            case .success(let recipes):
                self?.recipes = recipes
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailRecipeVC = segue.destination as? DetailRecipeController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("error")
        }
        let recipeInfo = recipes[indexPath.row]
        detailRecipeVC.recipeInfo = recipeInfo
    }
    
}

extension RecipeSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCell else {
            fatalError("could not dequeue a recipeCell")
        }
        let recipe = recipes[indexPath.row]
        cell.configureCell(for: recipe)
        
        return cell
    }
}

extension RecipeSearchController: UISearchBarDelegate {
    //activates search button
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // we will use guard let to unwrap the searchbar property because its an optional
            guard let searchText = searchBar.text else {
                print("missing search text")
                return
            }
            searchRecipes(searchQuary: searchText)
        }
    
}
extension RecipeSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
