//
//  SplashView.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool

    var body: some View {
        ZStack {
            Color.custPink
                .ignoresSafeArea()
            Image("splash")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}
