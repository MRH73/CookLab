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
    
    @State private var isPresenting = false
    @State private var newRecipe = Recipe()
    
    let category: MainInformation.Category
    
    var listForegroundColor = AppColor.foreground
    var listBackgroundColor = AppColor.background
    
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(recipes){ recipe in
                    NavigationLink(recipe.mainInformation.name,
                                   destination: RecipeDetailView(recipe: recipe))
                }
                .foregroundColor(listForegroundColor)
                .listRowBackground(listBackgroundColor)
            }
            .navigationTitle(Text(navigationTitle))
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresenting = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            })
            .sheet(isPresented: $isPresenting, content: {
                NavigationView{
                    ModifyRecipeView(recipe: $newRecipe)
                        .toolbar(content: {
                            
                            ToolbarItem(placement: .cancellationAction){
                                Button("Dismiss"){
                                    isPresenting = false
                                }
                            }
                            
                            ToolbarItem(placement: .confirmationAction){
                                
                                if newRecipe.isValid {
                                    Button("Add"){
                                        recipeData.add(recipe: newRecipe)
                                        isPresenting = false
                                    }
                                }
                            }
                        })
                        .navigationTitle(Text("Add a New Recipe"))
                }
            })
        }
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
        RecipesListView(category: .breakfast)
        .environmentObject(RecipeData())
    }
  }
}

