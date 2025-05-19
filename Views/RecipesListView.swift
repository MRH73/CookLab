//
//  ContentView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI
import SwiftData

struct RecipesListView: View {
    @StateObject var recipeData = RecipeData()
    
    var listForegroundColor = AppColor.foreground
    var listBackgroundColor = AppColor.background
    
    var body: some View {
        List{
            ForEach(recipies){ recipe in
                NavigationLink(recipe.mainInformation.name,
                               destination: RecipeDetailView(recipe: recipe))
            }
            .foregroundColor(listForegroundColor)
            .listRowBackground(listBackgroundColor)
        }
        .navigationTitle(Text(navigationTitle))
    }
}

extension RecipesListView{
    
    // Refactor of the recipeData inside the ForEach and of the nav title
    var recipies: [Recipe] {
        recipeData.recipes
    }
    
    var navigationTitle: String {
        "All Recipies"
    }
}

#Preview {
    NavigationStack {
        RecipesListView()
            .modelContainer(for: Item.self, inMemory: true)
    }
}

