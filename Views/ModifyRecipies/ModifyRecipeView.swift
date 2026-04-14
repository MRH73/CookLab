//
//  ModifyRecipeView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 1/6/25.
//

import SwiftUI

struct ModifyRecipeView: View {
    @Binding var recipe: Recipe

    var body: some View {
        Form {
            Section("Main Information") {
                TextField("Recipe name", text: $recipe.mainInformation.name)
                    .textInputAutocapitalization(.words)

                TextField("Description", text: $recipe.mainInformation.description, axis: .vertical)
                    .lineLimit(2 ... 4)

                TextField("Author", text: $recipe.mainInformation.author)
                    .textInputAutocapitalization(.words)

                Picker("Category", selection: $recipe.mainInformation.category) {
                    ForEach(MainInformation.Category.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }

            Section("Ingredients") {
                if recipe.ingredients.isEmpty {
                    Text("Add at least one ingredient.")
                        .foregroundStyle(.secondary)
                }

                ForEach($recipe.ingredients) { $ingredient in
                    IngredientEditorRow(ingredient: $ingredient)
                }
                .onDelete { offsets in
                    recipe.ingredients.remove(atOffsets: offsets)
                }

                Button {
                    recipe.ingredients.append(Ingredient())
                } label: {
                    Label("Add Ingredient", systemImage: "plus.circle.fill")
                }
            }

            Section("Directions") {
                if recipe.directions.isEmpty {
                    Text("Add at least one step.")
                        .foregroundStyle(.secondary)
                }

                ForEach($recipe.directions) { $direction in
                    DirectionEditorRow(direction: $direction)
                }
                .onDelete { offsets in
                    recipe.directions.remove(atOffsets: offsets)
                }

                Button {
                    recipe.directions.append(Direction())
                } label: {
                    Label("Add Step", systemImage: "plus.circle.fill")
                }
            }

            Section("Checklist") {
                ValidationRow(
                    title: "Recipe name, description, and author",
                    isComplete: recipe.mainInformation.isValid
                )
                ValidationRow(
                    title: "At least one ingredient",
                    isComplete: !recipe.cleaned.ingredients.isEmpty
                )
                ValidationRow(
                    title: "At least one direction",
                    isComplete: !recipe.cleaned.directions.isEmpty
                )
            }
        }
    }
}

private struct IngredientEditorRow: View {
    @Binding var ingredient: Ingredient

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Ingredient name", text: $ingredient.name)
                .textInputAutocapitalization(.words)

            HStack {
                TextField("Quantity", value: $ingredient.quantity, format: .number)
                    .keyboardType(.decimalPad)

                Picker("Unit", selection: $ingredient.unit) {
                    ForEach(Ingredient.Unit.allCases) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct DirectionEditorRow: View {
    @Binding var direction: Direction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Describe this step", text: $direction.description, axis: .vertical)
                .lineLimit(2 ... 4)

            Toggle("Optional step", isOn: $direction.isOptional)
        }
        .padding(.vertical, 4)
    }
}

private struct ValidationRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        Label {
            Text(title)
        } icon: {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? .green : .secondary)
        }
    }
}

struct ModifyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyRecipeView(recipe: .constant(Recipe(category: .breakfast)))
    }
}
