//
//  RecipeDetailView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        List {
            Section {
                Text(recipe.mainInformation.description)
                    .font(.body)
                    .foregroundStyle(AppColor.foreground)

                LabeledContent("Author", value: recipe.mainInformation.author)
                    .foregroundStyle(AppColor.foreground)
            }

            Section("Ingredients") {
                ForEach(recipe.ingredients) { ingredient in
                    if !ingredient.description.isEmpty {
                        Text(ingredient.description)
                            .foregroundStyle(AppColor.foreground)
                    }
                }
            }

            Section("Directions") {
                ForEach(Array(recipe.directions.enumerated()), id: \.element.id) { index, direction in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color.accentColor))

                        VStack(alignment: .leading, spacing: 4) {
                            if direction.isOptional {
                                Text("Optional")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }

                            Text(direction.description)
                                .foregroundStyle(AppColor.foreground)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColor.background.ignoresSafeArea())
        .navigationTitle(recipe.mainInformation.name)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeDetailView(recipe: Recipe.testRecipes[0])
        }
    }
}
