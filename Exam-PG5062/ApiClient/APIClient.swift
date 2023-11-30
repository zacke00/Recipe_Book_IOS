//
//  APIClient.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//

import Foundation
import CoreData

class APIClient {
    func fetchSequentially() {
        Task {
            await fetchAndSaveAreas()
            // Adding a delay of 1 second
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await fetchAndSaveCategories()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await fetchAndSaveIngredients()
            
        }
    }
    private func fetchAndSaveAreas() async {
        do {
            let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?a=list")!)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            let result = try JSONDecoder().decode(AreaResponse.self, from: data)
            let context = PersistenceController.shared.container.viewContext
            
            let fetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
            let existingAreas = try context.fetch(fetchRequest)
            
            var areasToSave = [AreaDetails]()
            for areaDetails in result.meals {
                if !existingAreas.contains(where: { $0.strArea == areaDetails.strArea }) {
                    let newArea = Area(context: context)
                    newArea.strArea = areaDetails.strArea
                }
            }
            
            try await context.save()
        } catch {
            print("Failed to save area: \(error)")
        }
    }
    
    private func fetchAndSaveCategories() async {
        do {
            let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            let result = try JSONDecoder().decode(CategoryResponse.self, from: data)
            let context = PersistenceController.shared.container.viewContext
            
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            let existingCategories = try context.fetch(fetchRequest)
            
            for categoryDetails in result.categories {
                if !existingCategories.contains(where: { $0.strCategory == categoryDetails.strCategory }) {
                    let newCategory = Category(context: context)
                    newCategory.strCategory = categoryDetails.strCategory
                    newCategory.strCategoryThumb = categoryDetails.strCategoryThumb
                }
            }
            
            try await context.save()
        } catch {
            print("Failed to save category: \(error)")
        }
    }
    
    func fetchAndSaveIngredients() async {
            do {
                let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list")!)
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                let decodedIngredients = try JSONDecoder().decode(IngredientsResponse.self, from: data)
                
                
                let context = PersistenceController.shared.container.viewContext
                saveIngredients(from: decodedIngredients.meals, in: context)
            } catch {
                print("Error fetching or saving ingredients: \(error)")
            }
        }

        private func saveIngredients(from details: [IngredientDetails], in context: NSManagedObjectContext) {
            details.forEach { detail in
                let ingredient = Ingredients(context: context)
                
                ingredient.strIngredient = detail.strIngredient
                
                
            }
            
            do {
                try context.save()
            } catch {
                print("Error saving ingredients: \(error)")
            }
        }
    
    func fetchAPIArea(for area: String) async -> [MealDetails] {
        do {
            let urlRequest = URLRequest(url: URL(string:
                                                    "www.themealdb.com/api/json/v1/1/filter.php?a=\(area)")!)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let result = try JSONDecoder().decode(MealsResponse.self, from: data)
            return result.meals ?? []
        } catch {
            print("Error during fetching meals: \(error)")
            return []
        }
    }
    
    func fetchMealsByIngredients(ingredients: String) async throws -> [MealDetails] {
        do {
            guard let apiUrl = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?i=\(ingredients)") else {
                print("Invalid API URL")
                return []
            }
            
            let urlRequest = URLRequest(url: apiUrl)
            
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            let result = try JSONDecoder().decode(MealsResponse.self, from: data)
            
            if let meals = result.meals, !meals.isEmpty {
                return meals
            } else {
                print("No meals found for the given query")
                return []
            }
        } catch let error {
            print(error)
            return []
        }
    }
    
    func fetchMealsForCategory(category: String) async throws -> [MealDetails] {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
        return mealsResponse.meals ?? []
    }
    
    func fetchMealsForArea(area: String) async throws -> [MealDetails] {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?a=\(area)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
        return mealsResponse.meals ?? []
    }
    
    
    func fetchAPI(for initialLetters: String) async -> [MealDetails] {
        do {
            // Encode the search term to handle spaces and other special characters
            guard let encodedSearchTerm = initialLetters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Error: Failed to encode search term")
                return []
            }
            
            let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encodedSearchTerm)")!)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Check if the response is an HTTP response and its status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Invalid HTTP response or status code not 200")
                return []
            }
            
            let result = try JSONDecoder().decode(MealsResponse.self, from: data)
            
            // Handle empty meals array in the response
            if let meals = result.meals, !meals.isEmpty {
                return meals
            } else {
                print("No meals found for the given query")
                return []
            }
        } catch {
            print("Error during fetching meals: \(error)")
            return []
        }
    }
    
    func fetchRandomMeal() async throws -> [MealDetails] {
        do{
            let urlrequest = URLRequest(url:URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!)
            let (data, _) = try await URLSession.shared.data(for: urlrequest)
            
            let result = try JSONDecoder().decode(MealsResponse.self, from: data)
            
            if let meals = result.meals, !meals.isEmpty {
                return meals
            } else {
                print("no Meals found for the given query")
                return []
            }
        }
        catch let error{
            print(error)
            return []
        }
    }
    
    
    func fetchMealByID(id: String) async throws -> [MealDetails]{
        do{
            let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            let result = try JSONDecoder().decode(MealsResponse.self, from: data)
            
            if let meals = result.meals, !meals.isEmpty {
                return meals
            } else {
                print("No meals found for the given query")
                return []
            }
        } catch let error {
            print(error)
            return []
        }
    }
}

