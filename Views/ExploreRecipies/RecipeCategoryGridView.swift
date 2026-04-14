//
//  RecipeCategoryGridView.swift
//  CookLab
//
//  Created by Miguel Ruiz on 23/5/25.
//

import SwiftUI

struct RecipeCategoryGridView: View {
    @EnvironmentObject private var recipeData: RecipeData

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]

        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(MainInformation.Category.allCases) { category in
                        NavigationLink(destination: RecipesListView(category: category)) {
                            CategoryView(
                                category: category,
                                recipeCount: recipeData.recipeCount(for: category)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(AppColor.background.ignoresSafeArea())
            .navigationTitle("CookLab")
        }
    }
}

struct CategoryView: View {
    let category: MainInformation.Category
    let recipeCount: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(category.rawValue)
                .resizable()
                .scaledToFill()
                .frame(height: 170)
                .clipped()

            LinearGradient(
                colors: [.clear, Color.black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("\(recipeCount) recipe\(recipeCount == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 10, y: 6)
    }
}

struct RecipeCategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCategoryGridView()
            .environmentObject(RecipeData())
    }
}
