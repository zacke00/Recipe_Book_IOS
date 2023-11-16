//
//  Category+CoreDataProperties.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var strCategoryThumb: String?
    @NSManaged public var strCategory: String?
    @NSManaged public var meal: NSSet?

}

// MARK: Generated accessors for meal
extension Category {

    @objc(addMealObject:)
    @NSManaged public func addToMeal(_ value: Meal)

    @objc(removeMealObject:)
    @NSManaged public func removeFromMeal(_ value: Meal)

    @objc(addMeal:)
    @NSManaged public func addToMeal(_ values: NSSet)

    @objc(removeMeal:)
    @NSManaged public func removeFromMeal(_ values: NSSet)

}

extension Category : Identifiable {

}
