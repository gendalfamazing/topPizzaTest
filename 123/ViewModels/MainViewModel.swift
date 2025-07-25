//
//  MainViewModel.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import SwiftUI
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var mealsByCategory: [String: [Meal]] = [:]
    @Published var selectedCategory: Category? = nil
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        Task {
            await loadCategoriesAndMeals()
        }
    }

    func loadCategoriesAndMeals() async {
        isLoading = true
        let categories = await APIService.shared.fetchCategories()
        await MainActor.run {
            self.categories = categories
            self.selectedCategory = categories.first
        }
        await withTaskGroup(of: (String, [Meal]).self) { group in
            for category in categories {
                group.addTask {
                    let meals = await APIService.shared.fetchMeals(for: category.name)
                    return (category.name, meals)
                }
            }
            var results: [String: [Meal]] = [:]
            for await (catName, meals) in group {
                results[catName] = meals
            }
            await MainActor.run {
                self.mealsByCategory = results
                self.isLoading = false
            }
        }
    }

    func selectCategory(_ category: Category, proxy: ScrollViewProxy) {
        selectedCategory = category
        withAnimation {
            proxy.scrollTo(category.id, anchor: .top)
        }
    }
}
