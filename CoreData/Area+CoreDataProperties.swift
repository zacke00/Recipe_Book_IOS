//
//  Area+CoreDataProperties.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//
//

import Foundation
import CoreData


extension Area {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Area> {
        return NSFetchRequest<Area>(entityName: "Area")
    }

    @NSManaged public var strArea: String?
    @NSManaged public var flagURL: String?
    @NSManaged public var meal: NSSet?

}

// MARK: Generated accessors for meal
extension Area {

    @objc(addMealObject:)
    @NSManaged public func addToMeal(_ value: Meal)

    @objc(removeMealObject:)
    @NSManaged public func removeFromMeal(_ value: Meal)

    @objc(addMeal:)
    @NSManaged public func addToMeal(_ values: NSSet)

    @objc(removeMeal:)
    @NSManaged public func removeFromMeal(_ values: NSSet)

}

extension Area : Identifiable {

}
