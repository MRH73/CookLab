//
//  RecipeData.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import Foundation

@MainActor
final class RecipeData: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []

    private let storageURL: URL = {
        let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        return baseURL
            .appendingPathComponent("CookLab", isDirectory: true)
            .appendingPathComponent("recipes.json")
    }()

    init() {
        loadRecipes()
    }

    func recipes(for category: MainInformation.Category) -> [Recipe] {
        recipes
            .filter { $0.mainInformation.category == category }
            .sorted { $0.mainInformation.name.localizedCaseInsensitiveCompare($1.mainInformation.name) == .orderedAscending }
    }

    func filteredRecipes(for category: MainInformation.Category, searchText: String) -> [Recipe] {
        let categoryRecipes = recipes(for: category)
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearch.isEmpty else {
            return categoryRecipes
        }

        return categoryRecipes.filter { recipe in
            recipe.mainInformation.name.localizedCaseInsensitiveContains(trimmedSearch)
                || recipe.mainInformation.description.localizedCaseInsensitiveContains(trimmedSearch)
                || recipe.mainInformation.author.localizedCaseInsensitiveContains(trimmedSearch)
        }
    }

    func recipeCount(for category: MainInformation.Category) -> Int {
        recipes.filter { $0.mainInformation.category == category }.count
    }

    @discardableResult
    func add(recipe: Recipe) -> Bool {
        let cleanedRecipe = recipe.cleaned

        guard cleanedRecipe.isValid else {
            return false
        }

        recipes.append(cleanedRecipe)
        persistRecipes()
        return true
    }

    func deleteRecipes(in category: MainInformation.Category, at offsets: IndexSet, matching searchText: String = "") {
        let visibleRecipes = filteredRecipes(for: category, searchText: searchText)
        let idsToDelete = offsets.map { visibleRecipes[$0].id }
        recipes.removeAll { idsToDelete.contains($0.id) }
        persistRecipes()
    }

    private func loadRecipes() {
        do {
            let data = try Data(contentsOf: storageURL)
            recipes = try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            recipes = Recipe.testRecipes
            persistRecipes()
        }
    }

    private func persistRecipes() {
        do {
            try FileManager.default.createDirectory(
                at: storageURL.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            let data = try encoder.encode(recipes)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            print("Failed to save recipes: \(error.localizedDescription)")
        }
    }
}
