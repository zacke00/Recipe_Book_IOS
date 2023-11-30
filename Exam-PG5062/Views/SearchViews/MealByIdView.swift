//
//  MealByIdView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 20/11/2023.
//

import SwiftUI

struct MealByIdView: View {
    var mealID: String
    var category: String
    var area: String
    
    @State private var meal: MealDetails?
    @State private var errorMessage: String?
    @ObservedObject var viewModel: MealViewModel
    
    var body: some View {
            VStack {
                if let meal = meal {
                    NavigationLink(destination: displayFocusedMealView(meal: meal, saveMeal: viewModel.saveMeal, viewModel: viewModel)) {
                        MealItemView(meals: meal, saveMealAction: {_ in
                                    viewModel.saveMeal(mealDetails: meal)
                                     // Update the state to show the confirmation
                                }, viewModel: viewModel)
                    }
                    .buttonStyle(FlatLinkStyle())
                    .onAppear {
                        fetchMealByID()
                    }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                } else {
                    ProgressView().onAppear {
                        
                        if category == ""{
                            fetchMealDetailsArea()
                        } else if area == "" {
                            fetchMealDetailsCategory()
                        } else {
                            fetchMealByID()
                        }
                    }
                }
            }

            
        }
                   
    private func fetchMealDetailsCategory() {
        
        if let cachedMeals = MealCache.shared.getMeals(forCategory: category),
           let cachedMeal = cachedMeals.first(where: { $0.idMeal == mealID }) {
            self.meal = cachedMeal
        } else {
            
            fetchMealByID()
        }
        
    }
    private func fetchMealDetailsArea() {
        
        
        if let cachedMeals = MealCache.shared.getMeals(forArea: area),
           let cachedMeal = cachedMeals.first(where: { $0.idMeal == mealID}){
            self.meal = cachedMeal
        } else {
            
            fetchMealByID()
        }
        
    }
    
    private func saveMealAndShowConfirmation(mealDetails: MealDetails) {
        viewModel.saveMeal(mealDetails: mealDetails)
        
    }
    
    private func fetchMealByID() {
        Task {
            do {
                let fetchedMeals = try await APIClient().fetchMealByID(id: mealID)
                if let fetchedMeal = fetchedMeals.first {
                    self.meal = fetchedMeal
                } else {
                    errorMessage = "Meal not found."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}


