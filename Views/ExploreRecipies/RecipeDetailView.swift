//
//  RecipeDetailView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var recipeData: RecipeData
    @State private var isPresentingEditor = false
    @State private var draftRecipe = Recipe()

    let recipeID: Recipe.ID

    var body: some View {
        Group {
            if let recipe {
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
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") {
                            draftRecipe = recipe
                            isPresentingEditor = true
                        }
                    }
                }
                .sheet(isPresented: $isPresentingEditor) {
                    NavigationStack {
                        ModifyRecipeView(recipe: $draftRecipe)
                            .navigationTitle("Edit Recipe")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {
                                        isPresentingEditor = false
                                    }
                                }

                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Save") {
                                        if recipeData.update(recipe: draftRecipe) {
                                            isPresentingEditor = false
                                        }
                                    }
                                    .disabled(!draftRecipe.isValid)
                                }
                            }
                    }
                }
            } else {
                ContentUnavailableView(
                    "Recipe not found",
                    systemImage: "fork.knife.circle",
                    description: Text("This recipe may have been deleted or moved.")
                )
                .navigationTitle("Recipe")
            }
        }
    }
}

extension RecipeDetailView {
    private var recipe: Recipe? {
        recipeData.recipe(withID: recipeID)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeDetailView(recipeID: Recipe.testRecipes[0].id)
                .environmentObject(RecipeData())
        }
    }
}
