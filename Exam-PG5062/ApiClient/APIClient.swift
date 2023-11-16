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
            await fetchAndSaveCategories()
            print("Categories fetch and save completed.")
            
            await fetchAndSaveAreas()
            print("Areas fetch and save completed.")
        }
    }
    
    func fetchAndSaveAreas() {
        Task {
            do {
                let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?a=list")!)
                let (data, _) = try await URLSession.shared.data(for: urlRequest)

                let result = try JSONDecoder().decode(AreaResponse.self, from: data)
                let context = PersistenceController.shared.container.viewContext

                let fetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
                let existingAreas = try context.fetch(fetchRequest)

                var areasToSave = [AreaDetails]()
                
                for areaDetails in result.meals {
                    if existingAreas.contains(where: { $0.strArea == areaDetails.strArea }) {
                        print("Area '\(areaDetails.strArea)' already exists in the database")
                    } else {
                        areasToSave.append(areaDetails)
                    }
                }

                for areaDetails in areasToSave {
                    let newArea = Area(context: context)
                    newArea.strArea = areaDetails.strArea
                    print("it worked area saved")
                }

                try context.save()
                print("context saved")
            } catch {
                print("Failed to save area: \(error)")
            }
        }
    }
    
    
    func fetchAndSaveCategories() {
        Task {
            do {
                let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!)
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                
                let result = try JSONDecoder().decode(CategoryResponse.self, from: data)
                let context = PersistenceController.shared.container.viewContext

                let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                let existingCategories = try context.fetch(fetchRequest)

                var categoriesToSave = [CategoryDetails]()
                
                for categoryDetails in result.categories {
                    if existingCategories.contains(where: { $0.strCategory == categoryDetails.strCategory }) {
                        print("Category '\(categoryDetails.strCategory)' already exists in the database")
                    } else {
                        categoriesToSave.append(categoryDetails)
                    }
                }

                for categoryDetails in categoriesToSave {
                    let newCategory = Category(context: context)
                    newCategory.strCategory = categoryDetails.strCategory
                    newCategory.strCategoryThumb = categoryDetails.strCategoryThumb
                    print("New category '\(categoryDetails.strCategory)' added")
                }

                try context.save()
                print("Context saved")
            } catch {
                print("Failed to save category: \(error)")
            }
        }
    }
    
    
    func fetchAPI(for initialLetters: String) async -> [MealDetails] {
        do {
            let urlRequest = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(initialLetters)")!)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let result = try JSONDecoder().decode(MealsResponse.self, from: data)
            return result.meals ?? []
        } catch {
            print("Error during fetching meals: \(error)")
            return []
        }
    }
}
