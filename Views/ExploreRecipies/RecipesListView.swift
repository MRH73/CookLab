//
//  ContentView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI
import SwiftData

struct RecipesListView: View {
    @EnvironmentObject private var recipeData: RecipeData
    
    let category: MainInformation.Category
    
    var listForegroundColor = AppColor.foreground
    var listBackgroundColor = AppColor.background
    
    var body: some View {
        List{
            ForEach(recipes){ recipe in
                NavigationLink(recipe.mainInformation.name,
                               destination: RecipeDetailView(recipe: recipe))
            }
            .foregroundColor(listForegroundColor)
            .listRowBackground(listBackgroundColor)
        }
        .navigationTitle(Text(navigationTitle))
    }
}

extension RecipesListView {
    
  private var recipes: [Recipe] {
    recipeData.recipes(for: category)
  }
  
  private var navigationTitle: String {
    "\(category.rawValue) Recipes"
  }
}


struct RecipesListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RecipesListView(category: .dinner)
        .environmentObject(RecipeData())
    }
  }
}

