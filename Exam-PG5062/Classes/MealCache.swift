//
//  MealCache.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 22/11/2023.
//

import Foundation
class MealCache {
    static let shared = MealCache()
    private init() {}

    var mealsByCategory: [String: [MealDetails]] = [:]
    var mealsByArea: [String: [MealDetails]] = [:]
    var mealsByName: [String: MealDetails] = [:]

    func clearCache() {
        mealsByCategory.removeAll()
        mealsByName.removeAll()
    }

    func saveMeals(_ meals: [MealDetails], forCategory category: String) {
            let lowercasedCategory = category.lowercased()
            mealsByCategory[lowercasedCategory] = mealsByCategory[lowercasedCategory] ?? []
            
            for meal in meals {
                let mealNameLowercased = meal.strMeal.lowercased()
                if mealsByName[mealNameLowercased] == nil {
                    mealsByName[mealNameLowercased] = meal
                    mealsByCategory[lowercasedCategory]?.append(meal)
                }
            }
        }

        func saveMeals(_ meals: [MealDetails], forArea area: String) {
            let lowercasedArea = area.lowercased()
            mealsByArea[lowercasedArea] = mealsByArea[lowercasedArea] ?? []
            
            for meal in meals {
                let mealNameLowercased = meal.strMeal.lowercased()
                if mealsByName[mealNameLowercased] == nil {
                    mealsByName[mealNameLowercased] = meal
                    mealsByArea[lowercasedArea]?.append(meal)
                }
            }
        }
    
    
    func getMeals(forCategory category: String) -> [MealDetails]? {
        return mealsByCategory[category.lowercased()]
    }
    func getMeals(forArea area: String) -> [MealDetails]? {
        return mealsByArea[area.lowercased()]
    }

    func getMeal(byName name: String) -> MealDetails? {
        return mealsByName[name.lowercased()]
    }
    func getAllCachedMeals() -> [MealDetails] {
        // Combine meals from both caches into a single array
        var allMeals = Array(mealsByName.values)
        let categoryMeals = mealsByCategory.values.flatMap { $0 }
        allMeals.append(contentsOf: categoryMeals.filter { !mealsByName.keys.contains($0.strMeal.lowercased()) })
        return allMeals
    }

}
