//
//  Meal+CoreDataProperties.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var idMeal: String?
    @NSManaged public var strMeal: String?
    @NSManaged public var strInstructions: String?
    @NSManaged public var strMealThumb: String?
    @NSManaged public var strTags: String?
    @NSManaged public var strYoutube: String?
    @NSManaged public var category: Category?
    @NSManaged public var area: Area?
    @NSManaged public var measurements: NSSet?

}


extension Meal : Identifiable {
    @objc(addMeasurementsObject:)
     @NSManaged public func addToMeasurements(_ value: Measurements)

     @objc(removeMeasurementsObject:)
     @NSManaged public func removeFromMeasurements(_ value: Measurements)

     @objc(addMeasurements:)
     @NSManaged public func addToMeasurements(_ values: NSSet)

     @objc(removeMeasurements:)
     @NSManaged public func removeFromMeasurements(_ values: NSSet)
}
