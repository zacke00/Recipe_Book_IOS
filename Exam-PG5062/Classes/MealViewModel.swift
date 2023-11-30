//
//  MealViewModel.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 27/11/2023.
//

import Foundation
import CoreData

class MealViewModel: ObservableObject {
    @Published var showSaveConfirmation = false
    func saveMeal(mealDetails: MealDetails) {
        let context = PersistenceController.shared.container.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "idMeal == %@", mealDetails.idMeal)

            do {
                let results = try context.fetch(fetchRequest)
                let newMeal: Meal

                if results.isEmpty {
                    newMeal = Meal(context: context)
                    newMeal.idMeal = mealDetails.idMeal
                    newMeal.strMeal = mealDetails.strMeal
                    newMeal.strInstructions = mealDetails.strInstructions
                    newMeal.strMealThumb = mealDetails.strMealThumb
                    newMeal.strTags = mealDetails.strTags
                    newMeal.strYoutube = mealDetails.strYoutube
                    newMeal.category = try self.fetchOrCreateCategory(withName: mealDetails.strCategory ?? "unknown", in: context)
                    newMeal.area = try self.fetchOrCreateArea(withName: mealDetails.strArea ?? "unknown", in: context)

                    // Create Measurements objects for each ingredient and its measure
                    for measurement in mealDetails.measurements {
                        let components = measurement.split(separator: ":").map { String($0).trimmingCharacters(in: .whitespaces) }
                        if components.count == 2 {
                            let ingredientName = components[0]
                            let measure = components[1]

                            let newMeasurement = Measurements(context: context)
                            newMeasurement.strIngredients = ingredientName
                            newMeasurement.strMeasure = measure
                            newMeasurement.meal = newMeal
                        }
                    }
                } else {
                    newMeal = results.first!
                }

                do {
                    try context.save()
                    DispatchQueue.main.async {
                        self.showSaveConfirmation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.showSaveConfirmation = false
                        }
                    }
                } catch {
                    print("Failed to save meal: \(error)")
                }
            } catch {
                print("Failed to fetch meal: \(error)")
            }
        }
    }
    
    
    func fetchOrCreateCategory(withName categoryName: String, in context: NSManagedObjectContext) throws -> Category {
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "strCategory == %@", categoryName)
        
        let categories = try context.fetch(categoryFetchRequest)
        if let category = categories.first {
            return category
        } else {
            let newCategory = Category(context: context)
            newCategory.strCategory = categoryName
            return newCategory
        }
    }
    
    func fetchOrCreateArea(withName areaName: String, in context: NSManagedObjectContext) throws -> Area {
        let areaFetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
        areaFetchRequest.predicate = NSPredicate(format: "strArea == %@", areaName)
        
        let areas = try context.fetch(areaFetchRequest)
        if let area = areas.first {
            return area
        } else {
            let newArea = Area(context: context)
            newArea.strArea = areaName
            return newArea
        }
    }
    func fetchOrCreateIngredient(withName name: String, in context: NSManagedObjectContext) throws -> Ingredients {
        let fetchRequest: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "strIngredient == %@", name)
        
        let results = try context.fetch(fetchRequest)
        if let existingIngredient = results.first {
            return existingIngredient
        } else {
            let newIngredient = Ingredients(context: context)
            newIngredient.strIngredient = name
            return newIngredient
        }
    }
    
    
    
}
