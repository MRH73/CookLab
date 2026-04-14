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
            ZStack {
                AppBackgroundView()

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
                                    .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(maxWidth: 680, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BrandTitleView()
                }
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
        AppColor.categoryAccent(for: category)
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
        ZStack {
            Image(category.rawValue)
                .resizable()
                .scaledToFill()
                .frame(height: 206)
                .clipped()

            LinearGradient(
                colors: [
                    AppColor.deepTeal.opacity(0.16),
                    AppColor.ink.opacity(0.38),
                    AppColor.ink.opacity(0.84)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 10) {
                Image(systemName: symbolName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColor.ink)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        accentColor.opacity(0.95),
                                        AppColor.accentSoft
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.35), lineWidth: 1)
                    )

                Text(category.rawValue)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(summary)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.90))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 220)

                Text("\(recipeCount) recipe\(recipeCount == 1 ? "" : "s")")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppColor.accentSoft)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.14), in: Capsule())
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .frame(height: 206)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.24), radius: 16, y: 10)
    }
}

private struct BrandTitleView: View {
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColor.deepTeal,
                                AppColor.ink
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 30, height: 30)

                Image(systemName: "fork.knife")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppColor.accentSoft)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppColor.mint.opacity(0.45), lineWidth: 1)
            )

            Text("CookLab")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            AppColor.accentSoft,
                            AppColor.mint
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.18), radius: 8, y: 2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.16), in: Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct HomeHeroView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    AppColor.deepTeal,
                    Color(red: 0.07, green: 0.36, blue: 0.40),
                    AppColor.ink
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 68))
                        .foregroundStyle(AppColor.accentSoft.opacity(0.2))
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
            .background(AppColor.mint.opacity(0.16), in: Capsule())
    }
}

struct RecipeCategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCategoryGridView()
            .environmentObject(RecipeData())
    }
}
