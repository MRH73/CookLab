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
        ZStack {
            AppBackgroundView()

            Group {
                if let recipe {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            RecipeHeroCard(recipe: recipe)

                            RecipeSectionCard(title: "Ingredients", systemName: "cart.fill") {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(recipe.ingredients) { ingredient in
                                        if !ingredient.description.isEmpty {
                                            HStack(alignment: .top, spacing: 10) {
                                                Circle()
                                                    .fill(AppColor.accentSoft)
                                                    .frame(width: 8, height: 8)
                                                    .padding(.top, 7)

                                                Text(ingredient.description)
                                                    .foregroundStyle(AppColor.foreground)
                                            }
                                        }
                                    }
                                }
                            }

                            RecipeSectionCard(title: "Directions", systemName: "list.number") {
                                VStack(spacing: 14) {
                                    ForEach(Array(recipe.directions.enumerated()), id: \.element.id) { index, direction in
                                        HStack(alignment: .top, spacing: 12) {
                                            Text("\(index + 1)")
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                                .frame(width: 34, height: 34)
                                                .background(Circle().fill(AppColor.accent))

                                            VStack(alignment: .leading, spacing: 6) {
                                                if direction.isOptional {
                                                    Text("Optional")
                                                        .font(.caption.weight(.semibold))
                                                        .foregroundStyle(AppColor.secondaryForeground)
                                                }

                                                Text(direction.description)
                                                    .foregroundStyle(AppColor.foreground)
                                            }

                                            Spacer(minLength: 0)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(14)
                                        .background(AppColor.secondaryBackground.opacity(0.95), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 18)
                        .padding(.bottom, 28)
                    }
                } else {
                    ContentUnavailableView(
                        "Recipe not found",
                        systemImage: "fork.knife.circle",
                        description: Text("This recipe may have been deleted or moved.")
                    )
                    .foregroundStyle(AppColor.accentSoft)
                }
            }
        }
        .navigationTitle(recipe?.mainInformation.name ?? "Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            if let recipe {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        draftRecipe = recipe
                        isPresentingEditor = true
                    }
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
            .presentationDetents([.large])
        }
    }
}

extension RecipeDetailView {
    private var recipe: Recipe? {
        recipeData.recipe(withID: recipeID)
    }
}

private struct RecipeHeroCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(recipe.mainInformation.category.rawValue.uppercased())
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(AppColor.accentSoft.opacity(0.84))

            Text(recipe.mainInformation.name)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(recipe.mainInformation.description)
                .font(.body)
                .foregroundStyle(AppColor.accentSoft.opacity(0.9))

            HStack(spacing: 10) {
                DetailPill(label: recipe.mainInformation.author, systemName: "person.fill")
                DetailPill(label: "\(recipe.ingredients.count) ingredients", systemName: "cart.fill")
                DetailPill(label: "\(recipe.directions.count) steps", systemName: "list.number")
            }
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

private struct RecipeSectionCard<Content: View>: View {
    let title: String
    let systemName: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: systemName)
                .font(.headline)
                .foregroundStyle(AppColor.foreground)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(AppColor.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct DetailPill: View {
    let label: String
    let systemName: String

    var body: some View {
        Label(label, systemImage: systemName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppColor.accentSoft)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.16), in: Capsule())
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
