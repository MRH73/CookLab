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
        ZStack {
            AppBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    EditorHeroCard(recipe: recipe)

                    EditorSectionCard(title: "Main Information", systemName: "text.book.closed.fill") {
                        VStack(spacing: 14) {
                            EditorField(title: "Recipe name") {
                                TextField("Recipe name", text: $recipe.mainInformation.name)
                                    .textInputAutocapitalization(.words)
                            }

                            EditorField(title: "Description") {
                                TextField("Description", text: $recipe.mainInformation.description, axis: .vertical)
                                    .lineLimit(2 ... 4)
                            }

                            EditorField(title: "Author") {
                                TextField("Author", text: $recipe.mainInformation.author)
                                    .textInputAutocapitalization(.words)
                            }

                            EditorField(title: "Category") {
                                Picker("Category", selection: $recipe.mainInformation.category) {
                                    ForEach(MainInformation.Category.allCases) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                    }

                    EditorSectionCard(title: "Ingredients", systemName: "cart.fill") {
                        VStack(spacing: 12) {
                            if recipe.ingredients.isEmpty {
                                EmptyEditorState(text: "Add at least one ingredient.")
                            }

                            ForEach($recipe.ingredients) { $ingredient in
                                IngredientEditorRow(ingredient: $ingredient) {
                                    recipe.ingredients.removeAll { $0.id == ingredient.id }
                                }
                            }

                            AddRowButton(title: "Add Ingredient", systemName: "plus.circle.fill") {
                                recipe.ingredients.append(Ingredient())
                            }
                        }
                    }

                    EditorSectionCard(title: "Directions", systemName: "list.number") {
                        VStack(spacing: 12) {
                            if recipe.directions.isEmpty {
                                EmptyEditorState(text: "Add at least one step.")
                            }

                            ForEach($recipe.directions) { $direction in
                                DirectionEditorRow(direction: $direction) {
                                    recipe.directions.removeAll { $0.id == direction.id }
                                }
                            }

                            AddRowButton(title: "Add Step", systemName: "plus.circle.fill") {
                                recipe.directions.append(Direction())
                            }
                        }
                    }

                    EditorSectionCard(title: "Checklist", systemName: "checkmark.seal.fill") {
                        VStack(spacing: 10) {
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
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

private struct EditorHeroCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recipe Studio")
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(AppColor.accentSoft.opacity(0.84))

            Text(recipe.mainInformation.name.isEmpty ? "Shape your next favorite dish." : recipe.mainInformation.name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Fill in the essentials, then build ingredients and steps in a cleaner editing flow.")
                .font(.subheadline)
                .foregroundStyle(AppColor.accentSoft.opacity(0.88))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(AppColor.panelGradient, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct EditorSectionCard<Content: View>: View {
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

private struct EditorField<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColor.secondaryForeground)

            content
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColor.secondaryBackground.opacity(0.95), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .foregroundStyle(AppColor.foreground)
        }
    }
}

private struct EmptyEditorState: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(AppColor.secondaryForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(AppColor.secondaryBackground.opacity(0.8), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct AddRowButton: View {
    let title: String
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppColor.accentSoft)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColor.deepTeal, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct IngredientEditorRow: View {
    @Binding var ingredient: Ingredient
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ingredient")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.foreground)

                Spacer()

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(AppColor.destructive.opacity(0.92), in: Circle())
                }
                .buttonStyle(.plain)
            }

            EditorField(title: "Ingredient name") {
                TextField("Ingredient name", text: $ingredient.name)
                    .textInputAutocapitalization(.words)
            }

            HStack(alignment: .top, spacing: 12) {
                EditorField(title: "Quantity") {
                    TextField("Quantity", value: $ingredient.quantity, format: .number)
                        .keyboardType(.decimalPad)
                }

                EditorField(title: "Unit") {
                    Picker("Unit", selection: $ingredient.unit) {
                        ForEach(Ingredient.Unit.allCases) { unit in
                            Text(unit.label).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .padding(14)
        .background(AppColor.secondaryBackground.opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct DirectionEditorRow: View {
    @Binding var direction: Direction
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Direction")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.foreground)

                Spacer()

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(AppColor.destructive.opacity(0.92), in: Circle())
                }
                .buttonStyle(.plain)
            }

            EditorField(title: "Step") {
                TextField("Describe this step", text: $direction.description, axis: .vertical)
                    .lineLimit(2 ... 4)
            }

            Toggle("Optional step", isOn: $direction.isOptional)
                .foregroundStyle(AppColor.foreground)
                .toggleStyle(.switch)
        }
        .padding(14)
        .background(AppColor.secondaryBackground.opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct ValidationRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        Label {
            Text(title)
                .foregroundStyle(AppColor.foreground)
        } icon: {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? AppColor.mint : AppColor.secondaryForeground)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppColor.secondaryBackground.opacity(0.82), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct ModifyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyRecipeView(recipe: .constant(Recipe(category: .breakfast)))
    }
}
