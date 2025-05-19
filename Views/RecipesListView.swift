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
    
    var body: some View {
        List{
            ForEach(recipeData.recipes){ recipe in 
                Text(recipe.mainInformation.name)
            }
        }.navigationTitle(Text(" All Recipes"))
    }
}

#Preview {
    RecipesListView()
        .modelContainer(for: Item.self, inMemory: true)
}
