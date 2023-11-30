//
//  Ingredients+CoreDataProperties.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 21/11/2023.
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
    

}





extension Ingredients : Identifiable {

}
