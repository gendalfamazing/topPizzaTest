//
//  RootView.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import Foundation
import SwiftUI

struct RootView: View {
    @AppStorage("isAuthorized") private var isAuthorized: Bool = false
    @State private var showSplash = true

    var body: some View {
        if showSplash {
            SplashView(showSplash: $showSplash)
        } else {
            if isAuthorized {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
