//
//  CookLabApp.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import SwiftUI

@main
struct CookLabApp: App {
    @StateObject private var recipeData = RecipeData()

    var body: some Scene {
        WindowGroup {
            RecipeCategoryGridView()
                .environmentObject(recipeData)
        }
    }
}
