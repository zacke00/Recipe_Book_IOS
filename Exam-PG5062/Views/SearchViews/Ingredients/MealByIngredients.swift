//
//  MealByIngredients.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 22/11/2023.
//

import SwiftUI
import SwiftUI

struct MealByIngredients: View {
    var ingredientName: String
    @State private var ingredientMeals: [MealDetails] = []
    @State private var meals: [MealDetails] = []
    
    
    
    var body: some View {
                    ZStack {
                        LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                ScrollView {
                    if !meals.isEmpty {
                        ForEach(meals, id: \.idMeal) { meal in
                            NavigationLink(destination: displayFocusedMealView(meal: meal, saveMeal: MealViewModel().saveMeal, viewModel: MealViewModel())) {
                                DisplayMealView(meal: meal, viewModel: MealViewModel())
                            }
                        }
                    } else {
                        VStack {
                            Text("I'm sorry, there are no recipes with:")
                            Text(ingredientName)
                        }
                    }
                }
            }.onAppear {
                fetchMealsByIngredient()
            }
        
    }
    
    private func fetchMealsByIngredient() {
        Task {
            do {
                 ingredientMeals = try await APIClient().fetchMealsByIngredients(ingredients: ingredientName)
                
                for meals in ingredientMeals {
                    try await fetchMealsById(mealID: meals.idMeal)
                }
            } catch {
                print("Error fetching meals by ingredient: \(error)")
            }
        }
    }
    
    private func fetchMealsById(mealID: String) {
        Task {
            do {
                let fetchedMeals = try await APIClient().fetchMealByID(id: mealID)
                let sortedMeals = fetchedMeals.sorted { $0.strMeal.localizedCompare($1.strMeal) == .orderedAscending }

                // Update the meals array on the main thread
                DispatchQueue.main.async {
                    for meal in sortedMeals {
                        if !self.meals.contains(where: { $0.idMeal == meal.idMeal }) {
                            self.meals.append(meal)
                        }
                    }
                }
            } catch {
                print("Failed to fetch meals by ID: \(error)")
            }
        }
    }
}
