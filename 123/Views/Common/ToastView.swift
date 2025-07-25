//
//  ToastView.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//


import SwiftUI

struct ToastView: View {
    let text: String
    var isError: Bool = false
    @State private var hide = false

    var body: some View {
        if !hide {
            HStack(spacing: 8) {
                Spacer()
                Text(text).font(.subheadline.bold())
                Spacer()
                Image(isError ? "close-circle" : "check-circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 12)
            .frame(height: 50)
            .background(Color.white)
            .foregroundColor(isError ? Color.custPink : Color.green.opacity(0.9))
            .cornerRadius(20)
            .padding(.horizontal, 16)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        hide = true
                    }
                }
            }
        }
    }
}
