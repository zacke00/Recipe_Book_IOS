//
//  Category+CoreDataClass.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, Decodable {

    enum CodingKeys: CodingKey {
        case strCategory
        case strCategoryThumb
    }
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    public required init(from decoder: Decoder) throws {
        let moc = PersistenceController.shared.container.viewContext
        let existingCategories = try moc.fetch(Category.fetchRequest())
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let strCategory = try container.decode(String.self, forKey: .strCategory)
        let strCategoryThumb = try container.decode(String.self, forKey: .strCategoryThumb)
        if existingCategories.contains(where: { $0.strCategory == strCategory }) {
            throw DatabaseError.duplicationError
        } else {
            super.init(entity: .entity(forEntityName: "Category", in: moc)!, insertInto: moc)
            self.strCategory = strCategory
            self.strCategoryThumb = strCategoryThumb
        }
    }
}

enum DatabaseError: Error {
    case duplicationError
}
