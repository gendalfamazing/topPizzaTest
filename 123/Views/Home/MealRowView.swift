//
//  MealRowView.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import SwiftUI

struct MealRowView: View {
    let meal: Meal
    let category: Category

    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            AsyncImage(url: URL(string: meal.imageUrl)) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.3)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Color.gray.opacity(0.3)
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 132, height: 132)
            .clipped()
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(meal.name)
                    .font(.subheadline)
                    .bold()
                Text(category.description)
                    .lineLimit(3)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                HStack {
                    Spacer()
                    Text(String(format: "€%.2f", meal.price))
                        .frame(width: 87, height: 32)
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.custPink)
                        .background(Color.clear)
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.custPink, lineWidth: 1)
                        )
                }
            }
            .frame(width: 171)
            Spacer()
        }
        .padding(.vertical, 24)
        .padding(.horizontal)
        Divider()
    }
}
