//
//  Area+CoreDataClass.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//
//

import Foundation
import CoreData
@objc(Area)
public class Area: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case strArea
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        let moc = PersistenceController.shared.container.viewContext
        let existingAreas = try moc.fetch(Area.fetchRequest())
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let strArea = try container.decode(String.self, forKey: .strArea)

        if existingAreas.contains(where: { $0.strArea == strArea }) {
            throw DatabaseError.duplicationError
        } else {
            super.init(entity: .entity(forEntityName: "Area", in: moc)!, insertInto: moc)
            self.strArea = strArea
        }
    }
}

