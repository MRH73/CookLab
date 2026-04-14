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
        NavigationStack {
            GeometryReader { proxy in
                let contentWidth = min(proxy.size.width - 32, 680)

                ZStack {
                    MainPageBackgroundView()

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            HomeHeroView()

                            VStack(alignment: .leading, spacing: 14) {
                                Text("Browse by meal")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)

                                ForEach(MainInformation.Category.allCases) { category in
                                    NavigationLink(destination: RecipesListView(category: category)) {
                                        CategoryView(
                                            category: category,
                                            recipeCount: recipeData.recipeCount(for: category)
                                        )
                                        .frame(width: contentWidth)
                                        .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .frame(width: contentWidth, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                        .padding(.bottom, 28)
                    }
                }
                .navigationTitle("CookLab")
                .toolbarBackground(.hidden, for: .navigationBar)
            }
        }
    }
}

struct CategoryView: View {
    let category: MainInformation.Category
    let recipeCount: Int

    private var summary: String {
        switch category {
        case .breakfast:
            return "Quick starts, weekend brunches, and easy morning favorites."
        case .lunch:
            return "Fresh bowls, salads, and midday meals that travel well."
        case .dinner:
            return "Comforting mains and family-style dishes for the evening."
        case .other:
            return "Desserts, snacks, and everything that does not fit the usual boxes."
        }
    }

    private var accentColor: Color {
        switch category {
        case .breakfast:
            return Color(red: 1.0, green: 0.78, blue: 0.45)
        case .lunch:
            return Color(red: 0.48, green: 0.77, blue: 0.59)
        case .dinner:
            return Color(red: 0.9, green: 0.42, blue: 0.35)
        case .other:
            return Color(red: 0.69, green: 0.61, blue: 0.49)
        }
    }

    private var symbolName: String {
        switch category {
        case .breakfast:
            return "sun.max.fill"
        case .lunch:
            return "leaf.fill"
        case .dinner:
            return "moon.stars.fill"
        case .other:
            return "birthday.cake.fill"
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(category.rawValue)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 190)
                .clipped()

            LinearGradient(
                colors: [.clear, Color.black.opacity(0.18), Color.black.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: symbolName)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.black.opacity(0.75))
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(accentColor))

                    Text("\(recipeCount) recipe\(recipeCount == 1 ? "" : "s")")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.86))

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.88))
                }

                Text(category.rawValue)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(summary)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.92))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.24), radius: 16, y: 10)
    }
}

private struct MainPageBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.12, blue: 0.1),
                    Color(red: 0.2, green: 0.15, blue: 0.12),
                    Color(red: 0.11, green: 0.17, blue: 0.14)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.orange.opacity(0.18))
                .frame(width: 240, height: 240)
                .blur(radius: 30)
                .offset(x: -110, y: -260)

            Circle()
                .fill(Color.green.opacity(0.14))
                .frame(width: 220, height: 220)
                .blur(radius: 40)
                .offset(x: 120, y: -20)

            Circle()
                .fill(Color.red.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: 80, y: 330)

            LinearGradient(
                colors: [
                    Color.black.opacity(0.2),
                    Color.clear,
                    Color.black.opacity(0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

private struct HomeHeroView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.56, blue: 0.28),
                    Color(red: 0.77, green: 0.28, blue: 0.23),
                    Color(red: 0.33, green: 0.16, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 68))
                        .foregroundStyle(.white.opacity(0.18))
                }
                Spacer()
            }
            .padding(20)

            VStack(alignment: .leading, spacing: 10) {
                Text("Your home for every recipe worth repeating.")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Explore breakfast, lunch, dinner, and extras in one clean kitchen notebook.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    HeroPill(label: "Organized")
                    HeroPill(label: "Fast")
                    HeroPill(label: "Personal")
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.28), radius: 18, y: 12)
    }
}

private struct HeroPill: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.white.opacity(0.14))
            .clipShape(Capsule())
    }
}

struct RecipeCategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCategoryGridView()
            .environmentObject(RecipeData())
    }
}
