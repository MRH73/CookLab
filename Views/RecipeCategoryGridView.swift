//
//  RecipeCategoryGridView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 23/5/25.
//

import SwiftUI

struct RecipeCategoryGridView: View {
    
    private let recipeData = RecipeData()
    
    var body: some View {
        
        let columns = [GridItem(), GridItem()]
        
        NavigationView{
            ScrollView{
                
                LazyVGrid(columns: columns, content: {
                        ForEach(MainInformation.Category.allCases,
                                id: \.self) { category in
                            
                            NavigationLink(
                              destination: RecipesListView(category: category)
                                .environmentObject(recipeData),
                              label: {
                                CategoryView(category: category)
                              })
                        }
                })
            } .navigationTitle(Text("Categories"))
        }
    }
}

struct CategoryView: View {
  let category: MainInformation.Category
  
  var body: some View {
    ZStack {
      Image(category.rawValue)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .opacity(0.35)
      Text(category.rawValue)
        .font(.title)
        .foregroundColor(.black)
    }
  }
}

#Preview {
    NavigationView {
        RecipeCategoryGridView()
    }
}
