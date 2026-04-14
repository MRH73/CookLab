//
// AppColor
//  CookLab
//
//  Created by Miguel Ruiz on 19/5/25.
//

import SwiftUI

struct AppColor {
    static let background = Color(uiColor: UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 11 / 255, green: 23 / 255, blue: 29 / 255, alpha: 1)
        default:
            return UIColor(red: 231 / 255, green: 243 / 255, blue: 242 / 255, alpha: 1)
        }
    })

    static let secondaryBackground = Color(uiColor: UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 18 / 255, green: 34 / 255, blue: 41 / 255, alpha: 1)
        default:
            return UIColor(red: 243 / 255, green: 251 / 255, blue: 249 / 255, alpha: 1)
        }
    })

    static let cardBackground = Color(uiColor: UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 22 / 255, green: 40 / 255, blue: 49 / 255, alpha: 0.94)
        default:
            return UIColor(red: 250 / 255, green: 255 / 255, blue: 254 / 255, alpha: 0.97)
        }
    })

    static let foreground = Color(uiColor: UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 228 / 255, green: 246 / 255, blue: 242 / 255, alpha: 1)
        default:
            return UIColor(red: 24 / 255, green: 56 / 255, blue: 62 / 255, alpha: 1)
        }
    })

    static let secondaryForeground = Color(uiColor: UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 155 / 255, green: 195 / 255, blue: 192 / 255, alpha: 1)
        default:
            return UIColor(red: 75 / 255, green: 112 / 255, blue: 118 / 255, alpha: 1)
        }
    })

    static let accent = Color(red: 72 / 255, green: 186 / 255, blue: 176 / 255)
    static let accentSoft = Color(red: 137 / 255, green: 233 / 255, blue: 215 / 255)
    static let mint = Color(red: 108 / 255, green: 214 / 255, blue: 198 / 255)
    static let deepTeal = Color(red: 14 / 255, green: 71 / 255, blue: 82 / 255)
    static let ink = Color(red: 9 / 255, green: 39 / 255, blue: 46 / 255)
    static let line = Color.white.opacity(0.12)
    static let destructive = Color(red: 150 / 255, green: 55 / 255, blue: 73 / 255)

    static let pageGradient = LinearGradient(
        colors: [
            Color(red: 0.03, green: 0.14, blue: 0.18),
            Color(red: 0.05, green: 0.22, blue: 0.27),
            Color(red: 0.02, green: 0.10, blue: 0.14)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let panelGradient = LinearGradient(
        colors: [
            Color(red: 0.09, green: 0.46, blue: 0.50),
            Color(red: 0.05, green: 0.28, blue: 0.33)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func categoryAccent(for category: MainInformation.Category) -> Color {
        switch category {
        case .breakfast:
            return Color(red: 137 / 255, green: 233 / 255, blue: 215 / 255)
        case .lunch:
            return Color(red: 96 / 255, green: 212 / 255, blue: 195 / 255)
        case .dinner:
            return Color(red: 74 / 255, green: 182 / 255, blue: 176 / 255)
        case .other:
            return Color(red: 108 / 255, green: 170 / 255, blue: 171 / 255)
        }
    }
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            AppColor.pageGradient
                .ignoresSafeArea()

            Circle()
                .fill(AppColor.accent.opacity(0.16))
                .frame(width: 240, height: 240)
                .blur(radius: 30)
                .offset(x: -110, y: -260)

            Circle()
                .fill(AppColor.mint.opacity(0.12))
                .frame(width: 220, height: 220)
                .blur(radius: 40)
                .offset(x: 120, y: -20)

            Circle()
                .fill(AppColor.deepTeal.opacity(0.18))
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
