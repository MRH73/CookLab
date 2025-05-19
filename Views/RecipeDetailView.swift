//
//  RecipeView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack{
            HStack{
                Text("Author: \(recipe.mainInformation.author)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            HStack{
                Text("Author: \(recipe.mainInformation.description)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            
        }.navigationTitle(recipe.mainInformation.name)
    }
}



// Preview

struct RecipeDetailView_Previews: PreviewProvider {
    
    @State static var recipe = Recipe.testRecipes[0]
    
    static var previews: some View {
        NavigationStack {
            RecipeDetailView(recipe: recipe)
        }
    }
}

