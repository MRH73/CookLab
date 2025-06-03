//
//  RecipeData.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import Foundation

class RecipeData: ObservableObject {
    @Published var recipes: [Recipe] = Recipe.testRecipes
    
    func recipes(for category: MainInformation.Category) -> [Recipe] {
        recipes.filter { $0.mainInformation.category == category }
    }
    
    func add(recipe: Recipe){
        if recipe.isValid{
            recipes.append(recipe)
        }
    }
}
