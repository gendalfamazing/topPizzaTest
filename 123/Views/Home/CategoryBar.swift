//
//  CategoryBar.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import SwiftUI

struct CategoryBar: View {
    let categories: [Category]
    @Binding var selectedCategory: Category?
    let proxy: ScrollViewProxy
    let onSelect: (Category, ScrollViewProxy) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    Button(action: {
                        onSelect(category, proxy)
                    }) {
                        Text(category.name)
                            .frame(width: 88, height: 32)
                            .font(.footnote)
                            .bold(selectedCategory == category ? true : false)
                            .foregroundColor(selectedCategory == category ? Color.custPink : Color.custPinkBack)
                            .background(selectedCategory == category ? Color.custPinkBack : Color.clear)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(selectedCategory == category ? Color.clear : Color.custPinkBack, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
        .background(.back)
    }
}
