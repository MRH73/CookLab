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
        ZStack {
            AppBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    RecipesHeaderCard(
                        category: category,
                        recipeCount: recipes.count,
                        searchText: searchText
                    )

                    if recipes.isEmpty {
                        ContentUnavailableView(
                            "No recipes yet",
                            systemImage: "fork.knife.circle",
                            description: Text("Add the first \(category.rawValue.lowercased()) recipe to start building your collection.")
                        )
                        .foregroundStyle(AppColor.accentSoft)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                        .background(AppColor.deepTeal.opacity(0.32), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                    } else {
                        VStack(spacing: 14) {
                            ForEach(recipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeID: recipe.id)) {
                                    RecipeRowView(recipe: recipe, category: category) {
                                        delete(recipeID: recipe.id)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.hidden, for: .navigationBar)
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
            .presentationDetents([.large])
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

    private func delete(recipeID: Recipe.ID) {
        guard let index = recipes.firstIndex(where: { $0.id == recipeID }) else {
            return
        }

        recipeData.deleteRecipes(in: category, at: IndexSet(integer: index), matching: searchText)
    }
}

private struct RecipesHeaderCard: View {
    let category: MainInformation.Category
    let recipeCount: Int
    let searchText: String

    private var title: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Ready to cook?" : "Search results"
    }

    private var subtitle: String {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Keep your \(category.rawValue.lowercased()) ideas in one polished space."
        }

        return "\(recipeCount) match\(recipeCount == 1 ? "" : "es") for “\(searchText)”"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.rawValue.uppercased())
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(AppColor.accentSoft.opacity(0.86))

            Text(title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(AppColor.accentSoft.opacity(0.88))

            HStack(spacing: 10) {
                Label("\(recipeCount) saved", systemImage: "book.closed.fill")
                Label("Swipe to delete", systemImage: "hand.draw.fill")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppColor.accentSoft.opacity(0.92))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(AppColor.panelGradient, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.22), radius: 18, y: 12)
    }
}

private struct RecipeRowView: View {
    let recipe: Recipe
    let category: MainInformation.Category
    let onDelete: () -> Void

    private var accentColor: Color {
        AppColor.categoryAccent(for: category)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 8) {
                Image(systemName: "fork.knife")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black.opacity(0.76))
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(accentColor))

                Text("\(recipe.ingredients.count)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(AppColor.secondaryForeground)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.mainInformation.name)
                    .font(.headline)
                    .foregroundStyle(AppColor.foreground)

                Text(recipe.mainInformation.description)
                    .font(.subheadline)
                    .foregroundStyle(AppColor.secondaryForeground)
                    .lineLimit(2)

                HStack(spacing: 10) {
                    RecipeMetaPill(label: recipe.mainInformation.author, systemName: "person.fill")
                    RecipeMetaPill(label: "\(recipe.directions.count) steps", systemName: "list.number")
                }
            }

            VStack(alignment: .trailing, spacing: 12) {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(AppColor.destructive.opacity(0.92), in: Circle())
                }
                .buttonStyle(.plain)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppColor.secondaryForeground)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 14, y: 8)
    }
}

private struct RecipeMetaPill: View {
    let label: String
    let systemName: String

    var body: some View {
        Label(label, systemImage: systemName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppColor.secondaryForeground)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(AppColor.secondaryBackground.opacity(0.9), in: Capsule())
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
