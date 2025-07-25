//
//  AllTabs.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image("menu")
                    Text("Меню")
                }
            Contacts()
                .tabItem {
                    Image("contacts")
                    Text("Контакты")
                }
            ProfileView()
                .tabItem {
                    Image("profile")
                    Text("Профиль")
                }
            CartView()
                .tabItem {
                    Image("cart")
                    Text("Корзина")
                }
        }
        .accentColor(Color.custPink)
    }
}

struct CartView: View {
    var body: some View {
        NavigationView {
            Text("Cart is empty")
                .navigationTitle("Cart")
        }
    }
}

struct Contacts: View {
    var body: some View {
        NavigationView {
            Text("No orders yet")
                .navigationTitle("Orders")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profile")
                .navigationTitle("Profile")
        }
    }
}
