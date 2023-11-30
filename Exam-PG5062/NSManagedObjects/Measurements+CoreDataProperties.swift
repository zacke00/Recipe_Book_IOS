//
//  Measurements+CoreDataProperties.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 21/11/2023.
//
//

import Foundation
import CoreData


extension Measurements {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurements> {
        return NSFetchRequest<Measurements>(entityName: "Measurements")
    }

    @NSManaged public var strIngredients: String?
    @NSManaged public var strMeasure: String?
    @NSManaged public var meal: Meal?

}

extension Measurements : Identifiable {

}
