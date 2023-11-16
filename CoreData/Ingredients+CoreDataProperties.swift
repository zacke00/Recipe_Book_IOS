//
//  Ingredients+CoreDataProperties.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//
//

import Foundation
import CoreData


extension Ingredients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredients> {
        return NSFetchRequest<Ingredients>(entityName: "Ingredients")
    }

    @NSManaged public var idIngredient: String?
    @NSManaged public var strIngredient: String?
    @NSManaged public var strDescription: String?
    @NSManaged public var strType: String?
    @NSManaged public var meal: Meal?

}

extension Ingredients : Identifiable {

}
