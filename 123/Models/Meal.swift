//
//  Meal.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//

import Foundation

struct Meal: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageUrl: String
    let price: Double
    let category: String
}

