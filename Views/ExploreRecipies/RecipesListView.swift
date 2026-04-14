//
//  RecipesListView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI

struct RecipesListView: View {
    @EnvironmentObject private var recipeData: RecipeData

    @State private var isPresenting = false
    @State private var draftRecipe = Recipe()
    @State private var searchText = ""

    let category: MainInformation.Category

    var body: some View {
        List {
            if recipes.isEmpty {
                ContentUnavailableView(
                    "No recipes yet",
                    systemImage: "fork.knife.circle",
                    description: Text("Add the first \(category.rawValue.lowercased()) recipe to start building your collection.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipeID: recipe.id)) {
                        RecipeRowView(recipe: recipe)
                    }
                }
                .onDelete { offsets in
                    recipeData.deleteRecipes(in: category, at: offsets, matching: searchText)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColor.background.ignoresSafeArea())
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search recipes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    draftRecipe = Recipe(category: category)
                    isPresenting = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            if !recipes.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $isPresenting, onDismiss: resetDraft) {
            NavigationStack {
                ModifyRecipeView(recipe: $draftRecipe)
                    .navigationTitle("New Recipe")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresenting = false
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if recipeData.add(recipe: draftRecipe) {
                                    isPresenting = false
                                }
                            }
                            .disabled(!draftRecipe.isValid)
                        }
                    }
            }
        }
    }
}

extension RecipesListView {
    private var recipes: [Recipe] {
        recipeData.filteredRecipes(for: category, searchText: searchText)
    }

    private var navigationTitle: String {
        "\(category.rawValue) Recipes"
    }

    private func resetDraft() {
        draftRecipe = Recipe(category: category)
    }
}

private struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(recipe.mainInformation.name)
                .font(.headline)
                .foregroundStyle(AppColor.foreground)

            Text(recipe.mainInformation.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 12) {
                Label(recipe.mainInformation.author, systemImage: "person.fill")
                Label("\(recipe.ingredients.count) ingredients", systemImage: "cart.fill")
                Label("\(recipe.directions.count) steps", systemImage: "list.number")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipesListView(category: .breakfast)
                .environmentObject(RecipeData())
        }
    }
}
