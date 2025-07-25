//
//  APIService.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import Foundation


final class APIService {
    static let shared = APIService()
    private init() {}

    func fetchCategories() async -> [Category] {
        let urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        guard let url = URL(string: urlString) else { return loadCachedCategories() ?? [] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CategoriesResponse.self, from: data)
            let categories = decoded.categories.map { dto in
                Category(
                    id: dto.idCategory,
                    name: dto.strCategory,
                    imageUrl: dto.strCategoryThumb,
                    description: dto.strCategoryDescription
                )
            }
            saveCategories(categories)
            return categories
        } catch {
            return loadCachedCategories() ?? []
        }
    }

    func fetchMeals(for categoryName: String) async -> [Meal] {
        let encodedCategory = categoryName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? categoryName
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(encodedCategory)"
        guard let url = URL(string: urlString) else { return loadCachedMeals()[categoryName] ?? [] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MealsResponse.self, from: data)
            let meals: [Meal] = decoded.meals.map { dto in
                Meal(
                    id: dto.idMeal,
                    name: dto.strMeal,
                    imageUrl: dto.strMealThumb,
                    price: Double.random(in: 5...20),
                    category: categoryName
                )
            }
            saveMeals(meals, for: categoryName)
            return meals
        } catch {
            return loadCachedMeals()[categoryName] ?? []
        }
    }

    private var categoriesFileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("categories_cache.json")
    }

    private var mealsFileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("meals_cache.json")
    }

    private func saveCategories(_ categories: [Category]) {
        do {
            let data = try JSONEncoder().encode(categories)
            try data.write(to: categoriesFileURL)
        } catch {
            print("Failed to save categories cache: \(error)")
        }
    }

    private func loadCachedCategories() -> [Category]? {
        guard let data = try? Data(contentsOf: categoriesFileURL) else { return nil }
        return try? JSONDecoder().decode([Category].self, from: data)
    }

    private func saveMeals(_ meals: [Meal], for categoryName: String) {
        var existing = loadCachedMeals()
        existing[categoryName] = meals
        do {
            let data = try JSONEncoder().encode(existing)
            try data.write(to: mealsFileURL)
        } catch {
            print("Failed to save meals cache: \(error)")
        }
    }

    private func loadCachedMeals() -> [String: [Meal]] {
        guard let data = try? Data(contentsOf: mealsFileURL) else { return [:] }
        return (try? JSONDecoder().decode([String: [Meal]].self, from: data)) ?? [:]
    }
}

private struct CategoriesResponse: Codable {
    let categories: [CategoryDTO]
}

private struct CategoryDTO: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

private struct MealsResponse: Codable {
    let meals: [MealDTO]
}

private struct MealDTO: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
