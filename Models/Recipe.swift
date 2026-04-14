import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    var id: UUID
    var mainInformation: MainInformation
    var ingredients: [Ingredient]
    var directions: [Direction]

    var isValid: Bool {
        cleaned.mainInformation.isValid
            && !cleaned.ingredients.isEmpty
            && !cleaned.directions.isEmpty
    }

    var cleaned: Recipe {
        Recipe(
            id: id,
            mainInformation: mainInformation.cleaned,
            ingredients: ingredients.map(\.cleaned).filter(\.isValid),
            directions: directions.map(\.cleaned).filter(\.isValid)
        )
    }

    init(
        id: UUID = UUID(),
        mainInformation: MainInformation,
        ingredients: [Ingredient],
        directions: [Direction]
    ) {
        self.id = id
        self.mainInformation = mainInformation
        self.ingredients = ingredients
        self.directions = directions
    }

    init(category: MainInformation.Category = .other) {
        self.init(
            mainInformation: MainInformation(category: category),
            ingredients: [],
            directions: []
        )
    }
}

struct MainInformation: Codable, Hashable {
    var name: String
    var description: String
    var author: String
    var category: Category

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var cleaned: MainInformation {
        MainInformation(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            author: author.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category
        )
    }

    init(
        name: String = "",
        description: String = "",
        author: String = "",
        category: Category = .other
    ) {
        self.name = name
        self.description = description
        self.author = author
        self.category = category
    }

    enum Category: String, CaseIterable, Codable, Hashable, Identifiable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case other = "Other"

        var id: String { rawValue }
    }
}

struct Direction: Identifiable, Codable, Hashable {
    var id: UUID
    var description: String
    var isOptional: Bool

    var isValid: Bool {
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var cleaned: Direction {
        Direction(
            id: id,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            isOptional: isOptional
        )
    }

    init(id: UUID = UUID(), description: String = "", isOptional: Bool = false) {
        self.id = id
        self.description = description
        self.isOptional = isOptional
    }
}

struct Ingredient: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var quantity: Double
    var unit: Unit

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && quantity > 0
    }

    var cleaned: Ingredient {
        Ingredient(
            id: id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            quantity: quantity,
            unit: unit
        )
    }

    var description: String {
        let formattedQuantity = quantity.formatted(.number.precision(.fractionLength(0 ... 2)))
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            return ""
        }

        switch unit {
        case .none:
            return "\(formattedQuantity) \(trimmedName)"
        default:
            let unitName = quantity == 1 ? unit.singularName : unit.rawValue
            return "\(formattedQuantity) \(unitName) \(trimmedName)"
        }
    }

    init(
        id: UUID = UUID(),
        name: String = "",
        quantity: Double = 1,
        unit: Unit = .none
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }

    enum Unit: String, CaseIterable, Codable, Hashable, Identifiable {
        case tsp = "teaspoons"
        case tbs = "tablespoons"
        case oz = "ounces"
        case cups = "cups"
        case gr = "grams"
        case ml = "milliliters"
        case none = "items"

        var id: String { rawValue }

        var singularName: String {
            switch self {
            case .tsp:
                return "teaspoon"
            case .tbs:
                return "tablespoon"
            case .oz:
                return "ounce"
            case .cups:
                return "cup"
            case .gr:
                return "gram"
            case .ml:
                return "milliliter"
            case .none:
                return "item"
            }
        }

        var label: String {
            switch self {
            case .none:
                return "No unit"
            default:
                return rawValue.capitalized
            }
        }
    }
}

extension Recipe {
    static let testRecipes: [Recipe] = [
        Recipe(
            mainInformation: MainInformation(
                name: "Dad's Mashed Potatoes",
                description: "Buttery salty mashed potatoes!",
                author: "Josh",
                category: .dinner
            ),
            ingredients: [
                Ingredient(name: "Potatoes", quantity: 454, unit: .gr),
                Ingredient(name: "Butter", quantity: 1, unit: .tbs),
                Ingredient(name: "Milk", quantity: 0.5, unit: .cups),
                Ingredient(name: "Salt", quantity: 2, unit: .tsp)
            ],
            directions: [
                Direction(description: "Put peeled potatoes in water and bring to boil for about 15 minutes, until they can be cut easily.", isOptional: false),
                Direction(description: "Soften the butter in the microwave for 30 seconds.", isOptional: true),
                Direction(description: "Drain the potatoes.", isOptional: false),
                Direction(description: "Mash vigorously with milk, salt, and butter.", isOptional: false)
            ]
        ),
        Recipe(
            mainInformation: MainInformation(
                name: "Beet and Apple Salad",
                description: "Light and refreshing summer salad made with beets, apples, and mint.",
                author: "Deb Szajngarten",
                category: .lunch
            ),
            ingredients: [
                Ingredient(name: "Large beet", quantity: 3, unit: .none),
                Ingredient(name: "Large apple", quantity: 2, unit: .none),
                Ingredient(name: "Lemon zest", quantity: 0.5, unit: .tbs),
                Ingredient(name: "Lemon juice", quantity: 1.5, unit: .tbs),
                Ingredient(name: "Olive oil", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Pepper", quantity: 1, unit: .tsp)
            ],
            directions: [
                Direction(description: "Cook the beets until tender, then let them cool completely.", isOptional: false),
                Direction(description: "Peel and dice the beets and apples.", isOptional: false),
                Direction(description: "Chiffonade the mint.", isOptional: false),
                Direction(description: "Toss everything with lemon zest, lemon juice, olive oil, salt, and pepper.", isOptional: false)
            ]
        ),
        Recipe(
            mainInformation: MainInformation(
                name: "Braised Beef Brisket",
                description: "Slow-cooked brisket with a rich, savory braise and plenty of gravy.",
                author: "Deb Szajngarten",
                category: .dinner
            ),
            ingredients: [
                Ingredient(name: "Brisket", quantity: 1815, unit: .gr),
                Ingredient(name: "Red onion", quantity: 1, unit: .none),
                Ingredient(name: "Garlic cloves", quantity: 6, unit: .none),
                Ingredient(name: "Large carrot", quantity: 1, unit: .none),
                Ingredient(name: "Parsnip", quantity: 1, unit: .none),
                Ingredient(name: "Celery stalks", quantity: 3, unit: .none),
                Ingredient(name: "Duck or chicken fat", quantity: 3, unit: .tbs),
                Ingredient(name: "Bay leaf", quantity: 1, unit: .none),
                Ingredient(name: "Apple cider vinegar", quantity: 0.3, unit: .cups),
                Ingredient(name: "Red wine", quantity: 1, unit: .cups),
                Ingredient(name: "Tomato paste", quantity: 1, unit: .none),
                Ingredient(name: "Honey", quantity: 1, unit: .tbs),
                Ingredient(name: "Chicken stock", quantity: 30, unit: .oz)
            ],
            directions: [
                Direction(description: "Mix the honey, tomato paste, and wine into a loose paste.", isOptional: false),
                Direction(description: "Brown the brisket in the fat, then set it aside.", isOptional: false),
                Direction(description: "Cook the vegetables until lightly softened.", isOptional: false),
                Direction(description: "Return the brisket to the pot with the remaining ingredients.", isOptional: false),
                Direction(description: "Cover and bake at 250 F until fork tender, about 4 to 6 hours.", isOptional: false)
            ]
        ),
        Recipe(
            mainInformation: MainInformation(
                name: "Best Brownies Ever",
                description: "Five simple ingredients make these brownies rich and easy to make.",
                author: "Pam Broda",
                category: .other
            ),
            ingredients: [
                Ingredient(name: "Condensed milk", quantity: 14, unit: .oz),
                Ingredient(name: "Crushed graham crackers", quantity: 2.5, unit: .cups),
                Ingredient(name: "Semi-sweet chocolate chips", quantity: 12, unit: .oz),
                Ingredient(name: "Vanilla extract", quantity: 1, unit: .tsp),
                Ingredient(name: "Milk", quantity: 2, unit: .tbs)
            ],
            directions: [
                Direction(description: "Preheat the oven to 350 F.", isOptional: false),
                Direction(description: "Mix the graham crackers, condensed milk, chocolate, vanilla, and milk.", isOptional: false),
                Direction(description: "Spread the batter into a greased 8x8-inch pan.", isOptional: false),
                Direction(description: "Bake for 23 to 25 minutes without overbaking.", isOptional: false)
            ]
        ),
        Recipe(
            mainInformation: MainInformation(
                name: "Omelet and Greens",
                description: "Quick omelet served with a bright lemony spinach salad.",
                author: "Taylor Murray",
                category: .breakfast
            ),
            ingredients: [
                Ingredient(name: "Olive oil", quantity: 3, unit: .tbs),
                Ingredient(name: "Onion, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Large eggs", quantity: 8, unit: .none),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Unsalted butter", quantity: 2, unit: .tbs),
                Ingredient(name: "Parmesan, finely grated", quantity: 1, unit: .oz),
                Ingredient(name: "Fresh lemon juice", quantity: 2, unit: .tbs),
                Ingredient(name: "Baby spinach", quantity: 3, unit: .oz)
            ],
            directions: [
                Direction(description: "Cook the onion in 1 tablespoon of olive oil until tender.", isOptional: false),
                Direction(description: "Whisk the eggs with salt and a splash of water.", isOptional: false),
                Direction(description: "Melt the butter in the skillet and add the eggs.", isOptional: false),
                Direction(description: "Stir until partially set, then cover and cook on low until just done.", isOptional: false),
                Direction(description: "Top with parmesan and onions, then fold the omelet.", isOptional: true),
                Direction(description: "Toss the spinach with lemon juice and remaining olive oil.", isOptional: false)
            ]
        ),
        Recipe(
            mainInformation: MainInformation(
                name: "Vegetarian Chili",
                description: "Warm, comforting, and filling vegetarian chili.",
                author: "Makinze Gore",
                category: .lunch
            ),
            ingredients: [
                Ingredient(name: "Chopped onion", quantity: 1, unit: .none),
                Ingredient(name: "Chopped red bell pepper", quantity: 1, unit: .none),
                Ingredient(name: "Carrot, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Garlic cloves", quantity: 3, unit: .none),
                Ingredient(name: "Jalapeno, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Tomato paste", quantity: 2, unit: .tbs),
                Ingredient(name: "Pinto beans", quantity: 1, unit: .none),
                Ingredient(name: "Black beans", quantity: 1, unit: .none),
                Ingredient(name: "Kidney beans", quantity: 1, unit: .none),
                Ingredient(name: "Fire-roasted tomatoes", quantity: 1, unit: .none),
                Ingredient(name: "Vegetable broth", quantity: 3, unit: .cups),
                Ingredient(name: "Chili powder", quantity: 2, unit: .tbs),
                Ingredient(name: "Cumin", quantity: 1, unit: .tbs),
                Ingredient(name: "Oregano", quantity: 2, unit: .tsp)
            ],
            directions: [
                Direction(description: "Saute the onion, bell pepper, carrot, and jalapeno until softened.", isOptional: false),
                Direction(description: "Add the garlic and tomato paste and cook until fragrant.", isOptional: false),
                Direction(description: "Stir in the beans, tomatoes, broth, and seasonings.", isOptional: false),
                Direction(description: "Bring to a boil, then reduce the heat and simmer for 30 minutes.", isOptional: false),
                Direction(description: "Serve with cheese, sour cream, or cilantro if desired.", isOptional: true)
            ]
        ),
        Recipe(
            mainInformation: MainInformation(
                name: "Classic Shrimp Scampi",
                description: "Simple shrimp scampi with pasta, garlic, lemon, and butter.",
                author: "Sarah Taller",
                category: .dinner
            ),
            ingredients: [
                Ingredient(name: "Linguini", quantity: 12, unit: .oz),
                Ingredient(name: "Large shrimp, peeled", quantity: 20, unit: .oz),
                Ingredient(name: "Extra-virgin olive oil", quantity: 0.33, unit: .cups),
                Ingredient(name: "Garlic cloves, minced", quantity: 5, unit: .none),
                Ingredient(name: "Red pepper flakes", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Dry white wine", quantity: 0.5, unit: .cups),
                Ingredient(name: "Lemon juice", quantity: 2, unit: .tbs),
                Ingredient(name: "Unsalted butter", quantity: 3, unit: .tbs),
                Ingredient(name: "Parsley, chopped", quantity: 2, unit: .tbs)
            ],
            directions: [
                Direction(description: "Cook the linguini in salted water until al dente.", isOptional: false),
                Direction(description: "Saute the shrimp with olive oil, garlic, and red pepper flakes.", isOptional: false),
                Direction(description: "Add the wine and lemon juice and simmer briefly.", isOptional: false),
                Direction(description: "Stir in the butter, parsley, and cooked pasta.", isOptional: false)
            ]
        )
    ]
}
