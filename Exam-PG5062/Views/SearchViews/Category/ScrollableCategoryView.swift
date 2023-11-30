//
//  ScrollableCategoryView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 16/11/2023.
//

import SwiftUI

struct ScrollableCategoryView: View {
    var categories:  FetchedResults<Category>
    
    
    var body: some View {
        VStack {
            Text("Categories")
                .bold()
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        
                        CategoryItemView(category: category)
                    }
                }.padding([.bottom, .top], 10)
            }
        }.padding(0)
    }
}

struct CategoryItemView: View {
    var category: Category
    
    
    var body: some View {
        VStack{
            NavigationLink(destination: MealsByCategory(category: category)) {
                ZStack {
                    Theme.third
                        .cornerRadius(10)
                        .shadow(color: Theme.shadowColor, radius: 5, x: 0, y: 3) // Add shadow here
                    
                    
                    VStack {
                        if let categoryName = category.strCategory {
                            if let categoryThumb = category.strCategoryThumb{
                                CustomImageView(urlString: categoryThumb)
                                
                                Text(category.strCategory ?? "unknown")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(Theme.text)
                            }
                        }
                    }
                    .padding([.top, .bottom], 5)
                }
                .frame(width: 110, height: 100)
                .padding([.leading], 5)
            }
        }
    }
}

struct MealsByCategory: View {
    var category: Category
    @State private var mealIDs: [String] = []
    @State private var isLoading: Bool = false
    @StateObject private var viewModel = MealViewModel()
    @State var showSaveConfirmation = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        ForEach(mealIDs, id: \.self) { mealID in
                            MealByIdView(mealID: mealID, category: category.strCategory!, area: "", viewModel: viewModel)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
            .navigationTitle(category.strCategory ?? "Category")
        .onAppear {
            fetchCategoryMeals()
        }
    }
    
    
    
    
    private func fetchCategoryMeals() {
        isLoading = true
        let categoryName = category.strCategory ?? ""
        
        if let cachedMeals = MealCache.shared.getMeals(forCategory: categoryName) {
            self.mealIDs = cachedMeals.map { $0.idMeal }
            isLoading = false
            return
        }
        
        Task {
            do {
                let meals = try await APIClient().fetchMealsForCategory(category: categoryName)
                DispatchQueue.main.async {
                    self.mealIDs = meals.map { $0.idMeal }
                    MealCache.shared.saveMeals(meals, forCategory: categoryName)
                    isLoading = false
                }
            } catch {
                print("Error fetching meals for category: \(error)")
                isLoading = false
            }
        }
    }
}
