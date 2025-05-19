//
//  RecipeData.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import Foundation

class RecipeData: ObservableObject {
    @Published var recipes: [Recipe] = Recipe.testRecipes
}
