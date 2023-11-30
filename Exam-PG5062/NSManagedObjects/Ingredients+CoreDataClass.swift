//
//  Ingredients+CoreDataClass.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 21/11/2023.
//
//

import Foundation
import CoreData

@objc(Ingredients)
public class Ingredients: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case idIngredients, strIngredients
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public required init(from decoder: Decoder) throws {
        let moc = PersistenceController.shared.container.viewContext
        super.init(entity: .entity(forEntityName: "Ingredients", in: moc)!, insertInto: moc)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idIngredient = try container.decodeIfPresent(String.self, forKey: .idIngredients)
        self.strIngredient = try container.decode(String.self, forKey: .strIngredients)
    }

    
    
}
