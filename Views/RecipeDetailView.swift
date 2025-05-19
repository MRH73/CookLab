//
//  RecipeView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var listForegroundColor = AppColor.foreground
    var listBackgroundColor = AppColor.background
    
    var body: some View {
        VStack{
            HStack{
                Text("Author: \(recipe.mainInformation.author)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            HStack{
                Text("\(recipe.mainInformation.description)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            
            //Ingredients List
            
            List{
                Section(header: Text("Ingredients")) {
                    ForEach(recipe.ingredients.indices, id: \.self){ index in
                        
                        let ingredient = recipe.ingredients[index]
                        Text(ingredient.description)
                            .foregroundColor(listForegroundColor)
                    }
                } .listRowBackground(listBackgroundColor)
            
            
            // Directions List
            
            
                Section(header: Text("Directions")) {
                    ForEach(recipe.directions.indices, id: \.self){ index in
                        
                        let direction = recipe.directions[index]
                        HStack{
                            Text("\(index + 1)")
                                .bold()
    
                            if direction.isOptional {
                                VStack{
                                    HStack{
                                        Text("(Optional)")
                                            .bold()
                                        Spacer()

                                    }
                                        Text("\(direction.description)")
                    
                                }
                            } else {
                                Text("\(direction.description)")
                            }
                                
                        }.foregroundColor(listForegroundColor)
                    }
                }.listRowBackground(listBackgroundColor)
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

