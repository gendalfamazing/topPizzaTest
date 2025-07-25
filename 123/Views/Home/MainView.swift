//
//  MainView.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var selectedCity = "Москва"
    @State private var showCityMenu = false
    @AppStorage("isAuthorized") private var isAuthorized: Bool = false
    @AppStorage("justLoggedIn") private var justLoggedIn: Bool = false
    @State private var showSuccessToast: Bool = false
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .back
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading menu…")
                    } else {
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVStack(alignment: .leading,
                                           pinnedViews: [.sectionHeaders]) {
                                    BannerCarouselView()
                                        .padding(.top, 24)
                                    Section(header:
                                        CategoryBar(
                                            categories: viewModel.categories,
                                            selectedCategory: $viewModel.selectedCategory,
                                            proxy: proxy,
                                            onSelect: { category, scrollProxy in
                                                viewModel.selectCategory(category,
                                                                         proxy: scrollProxy)
                                            }
                                        )
                                    ) {
                                        ForEach(viewModel.categories) { category in
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(category.name)
                                                    .font(.title)
                                                    .bold()
                                                    .padding(.horizontal)
                                                    .padding(.top, 16)
                                                    .padding(.bottom, 8)
                                                let meals = viewModel.mealsByCategory[category.name] ?? []
                                                ForEach(Array(meals.prefix(5))) { meal in
                                                    MealRowView(meal: meal, category: category)
                                                }
                                            }
                                            .background(Color.white)
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                                .background(Color.back)
                            }
                            .background(Color.back)
                        }
                    }
                }
                if showCityMenu {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(["Москва", "Санкт‑Петербург", "Нижний Новгород"],
                                id: \.self) { city in
                            Button(action: {
                                selectedCity = city
                                showCityMenu = false
                            }) {
                                Text(city)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .padding(.leading, 16)
                    .padding(.top, 8)
                    .zIndex(1)
                }
            }
            .overlay(alignment: .top) {
                if showSuccessToast && !viewModel.isLoading {
                    ToastView(text: "Вход выполнен успешно", isError: false)
                        .zIndex(2)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            showCityMenu.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(selectedCity)
                            Image(systemName: showCityMenu ? "chevron.up"
                                                            : "chevron.down")
                        }
                        .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                                   Button(action: {
                                       isAuthorized = false
                                   }) {
                                       Image(systemName: "rectangle.portrait.and.arrow.right")
                                   }
                               }
            }
            .onAppear {
                if justLoggedIn {
                    showSuccessToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSuccessToast = false
                            justLoggedIn = false
                        }
                    }
                }
            }
        }
    }
}
